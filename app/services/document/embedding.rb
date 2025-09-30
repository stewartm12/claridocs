class Document::Embedding
  def initialize
    @client = OpenAI::Client.new
  end

  def generate_embedding(text)
    response = @client.embeddings(
      parameters: {
        model: 'text-embedding-3-small', # or text-embedding-ada-002
        input: text
      }
    )

    response.dig('data', 0, 'embedding')
  rescue StandardError => e
    Rails.logger.error "Failed to generate embedding: #{e.message}"
    raise
  end
end
