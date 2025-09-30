class Document::SemanticSearch
  def initialize(collection = nil)
    @collection = collection
  end

  def search(query, limit: 10, similarity_threshold: 0.7)
    # Generate embedding for the query
    query_embedding = Document::Embedding.new.generate_embedding(query)

    # Build the base query
    chunks_query = DocumentChunk.joins(:document)
                               .includes(document: [:collection])
                               .with_embeddings

    # Filter by collection if specified
    if @collection
      chunks_query = chunks_query.where(documents: { collection: @collection })
    end

    # Find similar chunks
    similar_chunks = chunks_query
                      .nearest_neighbors(:embedding, query_embedding, distance: 'cosine')
                      .limit(limit * 2) # Get more results to filter by threshold

    # Filter by similarity threshold and format results
    results = similar_chunks.map do |chunk|
      distance = calculate_cosine_distance(query_embedding, chunk.embedding)
      similarity = 1 - distance

      next if similarity < similarity_threshold

      {
        chunk: chunk,
        document: chunk.document,
        similarity: similarity,
        content: chunk.content,
        summary: chunk.content_summary
      }
    end.compact.first(limit)

    # Generate AI response based on top results
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

  private

  def calculate_cosine_distance(vec1, vec2)
    # Simple cosine distance calculation
    dot_product = vec1.zip(vec2).map { |a, b| a * b }.sum
    magnitude1 = Math.sqrt(vec1.map { |a| a * a }.sum)
    magnitude2 = Math.sqrt(vec2.map { |a| a * a }.sum)

    1 - (dot_product / (magnitude1 * magnitude2))
  end

  def generate_ai_response(query, top_results)
    context = top_results.map do |result|
      "Document: #{result[:document].title}\n#{result[:content]}"
    end.join("\n\n---\n\n")

    Document::Ai.new.chat(
      "Based on the following document excerpts, please answer this question: #{query}\n\nContext:\n#{context}"
    )
  end
end
