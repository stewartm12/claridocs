class Document::Processing
  MAX_CHUNK_SIZE = 1000 # tokens
  CHUNK_OVERLAP = 200   # tokens overlap between chunks

  def initialize(document)
    @document = document
  end

  def call
    return false unless @document.file.attached?

    @document.update!(processing_status: :processing, processed_at: nil)

    begin
      # Extract text content
      content = extract_content
      return mark_as_failed('No content extracted') if content.blank?

      # Generate AI summary
      summary = generate_document_summary(content)

      # Extract metadata
      metadata = extract_document_metadata(content)

      # Create chunks
      chunks = create_chunks(content)

      # Generate embeddings for chunks
      generate_embeddings(chunks)

      # Update document
      @document.update!(
        processing_status: :completed,
        processed_at: Time.current,
        chunk_count: chunks.count,
        ai_summary: summary,
        extracted_metadata: metadata,
        content_hash: calculate_content_hash
      )

      true
    rescue StandardError => e
      Rails.logger.error "Document processing failed for #{@document.id}: #{e.message}"
      mark_as_failed(e.message)
      false
    end
  end

  private

  def extract_content
    case @document.file.content_type
    when 'text/plain'
      @document.file.download
    when 'application/pdf'
      extract_pdf_content
    when /application\/(vnd\.openxmlformats-officedocument\.wordprocessingml\.document|msword)/
      extract_word_content
    else
      raise "Unsupported file type: #{@document.file.content_type}"
    end
  end

  def extract_pdf_content
    # Using pdf-reader gem or similar
    # require 'pdf/reader'

    reader = PDF::Reader.new(StringIO.new(@document.file.download))
    reader.pages.map(&:text).join("\n")
  end

  def extract_word_content
    # Using docx gem or similar for .docx files
    # require 'docx'

    doc = Docx::Document.open(StringIO.new(@document.file.download))
    doc.paragraphs.map(&:text).join("\n")
  end

  def create_chunks(content)
    chunks = []
    sentences = content.split(/[.!?]+/).map(&:strip).reject(&:blank?)

    current_chunk = ''
    chunk_index = 0

    sentences.each do |sentence|
      test_chunk = current_chunk.blank? ? sentence : "#{current_chunk}. #{sentence}"

      if estimate_tokens(test_chunk) > MAX_CHUNK_SIZE && current_chunk.present?
        # Save current chunk
        chunks << create_chunk(current_chunk, chunk_index)
        chunk_index += 1

        # Start new chunk with overlap
        current_chunk = get_overlap_content(current_chunk) + sentence
      else
        current_chunk = test_chunk
      end
    end

    # Don't forget the last chunk
    if current_chunk.present?
      chunks << create_chunk(current_chunk, chunk_index)
    end

    chunks
  end

  def create_chunk(content, index)
    @document.document_chunks.create!(
      content: content,
      chunk_index: index,
      character_count: content.length,
      metadata: {
        created_by: 'DocumentProcessingService',
        processing_version: '1.0'
      }
    )
  end

  def get_overlap_content(content)
    # Get last N characters for overlap
    overlap_chars = [content.length, CHUNK_OVERLAP * 4].min
    content.last(overlap_chars)
  end

  def estimate_tokens(text)
    # Simple estimation: ~4 characters per token
    (text.length / 4.0).ceil
  end

  def generate_embeddings(chunks)
    embedding_service = Document::Embedding.new

    chunks.each do |chunk|
      embedding = embedding_service.generate_embedding(chunk.content)
      chunk.update!(embedding: embedding)

      # Generate chunk summary if content is long enough
      if chunk.character_count > 500
        summary = generate_chunk_summary(chunk.content)
        chunk.update!(content_summary: summary)
      end
    end
  end

  def generate_document_summary(content)
    # Use AI service to generate summary
    Document::Ai.new.generate_summary(content, max_length: 500)
  rescue StandardError => e
    Rails.logger.error "Failed to generate document summary: #{e.message}"
    nil
  end

  def generate_chunk_summary(content)
    # Use AI service to generate chunk summary
    Document::Ai.new.generate_summary(content, max_length: 200)
  rescue StandardError => e
    Rails.logger.error "Failed to generate chunk summary: #{e.message}"
    nil
  end

  def extract_document_metadata(content)
    # Extract metadata using AI
    Document::Ai.new.extract_metadata(content)
  rescue StandardError => e
    Rails.logger.error "Failed to extract metadata: #{e.message}"
    {}
  end

  def mark_as_failed(error_message)
    @document.update!(
      processing_status: :failed,
      extracted_metadata: { error: error_message, failed_at: Time.current }
    )
    false
  end

  def calculate_content_hash
    Digest::SHA256.hexdigest(@document.file.download)
  end
end
