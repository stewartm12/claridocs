class Document < ApplicationRecord
  include DocumentTypeMappings

  has_one_attached :file

  belongs_to :collection, counter_cache: true
  has_one :user, through: :collection
  has_many :document_chunks, dependent: :destroy

  validates :title, presence: true, uniqueness: { scope: :collection_id, case_sensitive: false }
  validate :acceptable_file_type

  before_validation :set_file_metadata, on: :create

  after_create_commit :process_document_async, if: :ai_extract?

  MEDIA_TYPES = %w[image video audio].freeze

  enum :processing_status, {
    pending: 0,
    processing: 1,
    completed: 2,
    failed: 3,
    needs_reprocessing: 4,
    not_processable: 5
  }

  scope :processed, -> { where(processing_status: :completed) }
  scope :ready_for_processing, -> { where(processing_status: %i[pending needs_reprocessing]) }

  def semantic_search(query, limit: 5)
    return DocumentChunk.none unless completed?

    embedding = Document::Embedding.new.generate_embedding(query)

    document_chunks
      .nearest_neighbors(:embedding, embedding, distance: 'cosine')
      .limit(limit)
      .includes(:document)
  end

  def process_ai!
    process_document_async
  end

  private

  def acceptable_file_type
    return unless file.attached?

    if MEDIA_TYPES.any? { |type| file.content_type.start_with?(type) }
      errors.add(:file, 'cannot be an image, video, or audio file')
    end
  end

  def set_file_metadata
    return unless file.attached?

    self.document_type = self.class.from_mime(file.content_type)
    self.title = File.basename(file.filename.to_s, File.extname(file.filename.to_s))
    self.size_bytes = file.blob.byte_size
  end

  def process_document_async
    DocumentProcessingJob.perform_later(id)
  end

  def calculate_content_hash
    return nil unless file.attached?

    Digest::SHA256.hexdigest(file.download)
  end
end
