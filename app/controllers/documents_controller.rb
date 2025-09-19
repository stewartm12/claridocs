class DocumentsController < ApplicationController
  before_action :set_document, only: %i[edit update destroy]

  def show; end

  def new
    @document = collection.documents.new
  end

  def create
    @document = collection.documents.new(create_params)

    if @document.save
      flash.now[:success] = 'Document uploaded successfully'
    else
      flash.now[:alert] = @document.errors.full_messages.to_sentence
    end
  end

  def edit; end

  def update
    if @document.update(update_params)
      flash.now[:success] = 'Document updated successfully'
    else
      flash.now[:alert] = @document.errors.full_messages.to_sentence
    end
  end

  def destroy
    @document.destroy!
    flash.now[:success] = 'Document Deleted Successfully.'
  end

  private

  def create_params
    params.expect(document: %i[description file])
  end

  def update_params
    params.expect(document: %i[title description])
  end

  def collection
    @collection ||= current_user.collections.find(params[:collection_id])
  end

  def set_document
    @document = collection.documents.find(params[:id])
  end
end
