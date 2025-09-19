class CollectionsController < ApplicationController
  def index
    @total_collections = current_user.collections_count
    @total_documents = current_user.documents_count
    @collections = current_user.collections
  end

  def show
    @collection = current_user.collections.find(params[:id])
  end

  def new
    @collection = current_user.collections.new
  end

  def edit
    @collection = current_user.collections.find(params[:id])
  end

  def create
    @collection = current_user.collections.new(collection_params)

    if @collection.save
     flash.now[:success] = 'Collection created successfully'
    else
      flash.now[:alert] = @collection.errors.full_messages.to_sentence
    end
  end

  def update
    @collection = current_user.collections.find(params[:id])

    if @collection.update(collection_params)
     flash.now[:success] = 'Collection updated successfully'
    else
      flash.now[:alert] = @collection.errors.full_messages.to_sentence
    end
  end

  def destroy
    @collection = current_user.collections.find(params[:id])
    @collection.destroy!
    flash.now[:success] = 'Successfully deleted collection'
  end

  private

  def collection_params
    params.expect(collection: %i[title description])
  end
end
