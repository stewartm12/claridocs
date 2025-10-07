class SearchController < ApplicationController
  def index
    query = params[:q]
    scope = params[:scope]
    target_id = params[:target_id] || 'search_results' # Default to desktop

    # Return empty if query is blank
    if query.blank?
      return render turbo_stream: turbo_stream.update(
        target_id,
        ''
      )
    end

    # Determine the search scope
    service = case scope
    when 'collection'
      Document::SemanticSearch.new(collection)
    when 'document'
      document = collection.documents.find(params[:document_id])
      Document::SemanticSearch.new(document)
    else
      Document::SemanticSearch.new(current_user) # Default to global
    end

    # Perform search
    results = service.search(query, limit: 10)

    # Render results
    render turbo_stream: turbo_stream.update(
      target_id,
      partial: 'shared/search_results',
      locals: {
        results: results[:results],
        ai_response: results[:ai_response],
        query: query,
        total_documents: results[:total_documents]
      }
    )
  end

  private

  def collection
    current_user.collections.find(params[:collection_id])
  end
end
