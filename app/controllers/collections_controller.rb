class CollectionsController < ApplicationController
  before_action :set_metrics, only: :index
  before_action :set_collection, only: %i[show edit update destroy]

  SORTABLE_COLUMNS = %w[title created_at updated_at size_bytes document_type].freeze

  def index
    @collections = current_user.collections
  end

  def show
    @documents = filtered_and_sorted_documents
  end

  def new
    @collection = current_user.collections.new
  end

  def edit; end

  def create
    @collection = current_user.collections.new(collection_params)

    if @collection.save
      set_metrics
      flash.now[:success] = 'Collection created successfully'
    else
      flash.now[:alert] = @collection.errors.full_messages.to_sentence
    end
  end

  def update
    @source = params[:source] || 'single_collection'

    if @collection.update(collection_params)
     flash.now[:success] = 'Collection updated successfully'
    else
      flash.now[:alert] = @collection.errors.full_messages.to_sentence
    end
  end

  def destroy
    @collection.destroy!

    respond_to do |format|
      format.turbo_stream do
        set_metrics
        flash.now[:success] = 'Successfully Deleted Document'
      end

      format.html { redirect_to collections_path, success: 'Successfully Deleted Document' }
    end
  end

  private

  def collection_params
    params.expect(collection: %i[title description])
  end

  def set_collection
    @collection = current_user.collections.find(params[:id])
  end

  def set_metrics
    @total_collections = current_user.collections_count
    @total_documents = current_user.documents_count
  end

  def filtered_and_sorted_documents
    documents = @collection.documents
    documents = filter_by_title(documents)
    documents = filter_by_type(documents)
    sort_documents(documents)
  end

  def filter_by_title(documents)
    return documents unless params[:title].present?

    documents.where('title ILIKE ?', "%#{params[:title]}%")
  end

  def filter_by_type(documents)
    return documents unless params[:type].present?

    documents.where(document_type: params[:type])
  end

  def sort_documents(documents)
    if valid_sort_column?
      documents.order(params[:sort].to_sym => :desc)
    else
      documents.order(created_at: :desc)
    end
  end

  def valid_sort_column?
    params[:sort].present? && SORTABLE_COLUMNS.include?(params[:sort])
  end
end
