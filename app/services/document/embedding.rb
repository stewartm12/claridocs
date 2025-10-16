class Document::Embedding
  def initialize(user)
    @user = user
    @active_embedding = user.active_embedding_model
    @client = OpenAI::Client.new(access_token: @user.active_chat_integration&.access_token)
  end

  def generate_embedding(text)
    response = @client.embeddings(
      parameters: {
        model: @active_embedding&.name,
        input: text
      }
    )

    response.dig('data', 0, 'embedding')
  rescue StandardError => e
    Rails.logger.error "Failed to generate embedding: #{e.message}"
    raise
  end
end
