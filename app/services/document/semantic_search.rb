class Document::SemanticSearch
  def initialize(scope = nil, user = nil)
    @scope = scope
    @user = user
  end

  def search(query, limit: 10, similarity_threshold: 0.7)
    if @user.has_ai_integration?
      message = "I couldn't find relevant information to answer your question."
      # Determine which search method to call based on scope
      similar_chunks = case @scope
      when Document
        DocumentChunk.similarity_search_in_document(query, document: @scope, user: @user, limit: limit * 2)
      when Collection
        DocumentChunk.similarity_search_in_collection(query, collection: @scope, user: @user, limit: limit * 2)
      when User
        DocumentChunk.similarity_search_for_user(query, user: @scope, limit: limit * 2)
      else
        raise ArgumentError, "Unsupported scope: #{@scope.class}"
      end

      # Filter by similarity threshold
      results = similar_chunks.map do |chunk|
        {
          document: chunk.document,
          content: chunk.content,
          summary: chunk.content_summary
        }
      end

      build_response(query, results, message: message)
    else
      message = 'No AI integration found. Please set up an AI integration to use semantic search.'
      build_response(query, [], message: message)
    end
  end

  private

  def build_response(query, results, message:)
    if results.any?
      ai_response = generate_ai_response(query, results.first(3))
      {
        query: query,
        ai_response: ai_response,
        results: results,
        total_documents: results.map { |r| r[:document].id }.uniq.count
      }
    else
      {
        query: query,
        ai_response: message,
        results: [],
        total_documents: 0
      }
    end
  end

  def generate_ai_response(query, top_results)
    context = top_results.map { |r| "Document: #{r[:document].title}\n#{r[:content]}" }.join("\n\n---\n\n")

    prompt = if @scope.is_a?(Document)
      "Based on the following excerpts from '#{@scope.title}', please answer this question in clear, plain text without using Markdown, asterisks, lists, or tables. Do not include any formatting — just write full sentences and paragraphs.\n\nQuestion: #{query}\n\nContext:\n#{context}"
    else
      "Based on the following document excerpts, please answer this question in clear, plain text without using Markdown, asterisks, lists, or tables. Do not include any formatting — just write full sentences and paragraphs.\n\nQuestion: #{query}\n\nContext:\n#{context}"
    end

    Document::Ai.new(@user).chat(prompt)
  end
end
