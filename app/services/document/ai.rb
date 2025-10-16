class Document::Ai
  def initialize(user)
    @user = user
    @active_chat = user.active_chat_model
    @client = OpenAI::Client.new(access_token: @user.active_chat_integration&.access_token)
  end

  def chat(content)
    response = @client.chat(
      parameters: {
        model: @active_chat&.name, # chat_integration.ac
        messages: [
          { role: 'system', content: 'You are a helpful assistant that answers questions or provides information based on input.' },
          { role: 'user', content: content }
        ],
        max_tokens: 500,
        temperature: 0.0
      }
    )

    response.dig('choices', 0, 'message', 'content')
  end

  def generate_summary(content, max_length: 300)
    response = @client.chat(
      parameters: {
        model: @active_chat&.name,
        messages: [
          {
            role: 'system',
            content: 'You are a helpful assistant that creates concise summaries.'
          },
          {
            role: 'user',
            content: Prompts::Document.summary(content)
          }
        ],
        temperature: 0.0,
        max_tokens: 500
      }
    )

    response.dig('choices', 0, 'message', 'content')
  end

  def extract_metadata(content)
    response = @client.chat(
      parameters: {
        model: @active_chat&.name,
        messages: [
          {
            role: 'system',
            content: 'You are an assistant that extracts structured metadata from documents (contracts, agreements, medical records, veterinary notes, invoices, etc.).'
          },
          {
            role: 'user',
            content: Prompts::Document.info_extraction(content)
          }
        ],
        max_tokens: 3000,
        temperature: 0.0,
        response_format: { type: 'json_object' }
      }
    )

    result = response.dig('choices', 0, 'message', 'content')

    JSON.parse(result)
  rescue JSON::ParserError
    { raw_extraction: result }
  end
end
