class Document::SemanticSearch
  def initialize(user, scope = nil)
    @user = user
    @scope = scope
  end

  def search(query, limit: 10, similarity_threshold: 0.7)
    # Determine which search method to call based on scope
    similar_chunks = case @scope
    when Document
      DocumentChunk.similarity_search_in_document(query, document: @scope, limit: limit * 2)
    when Collection
      DocumentChunk.similarity_search_in_collection(query, collection: @scope, limit: limit * 2)
    when NilClass
      DocumentChunk.similarity_search_for_user(query, user: @user, limit: limit * 2)
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

    build_response(query, results)
  end

  private

  def build_response(query, results)
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
        ai_response: "I couldn't find relevant information to answer your question.",
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

    Document::Ai.new.chat(prompt)
  end
end
