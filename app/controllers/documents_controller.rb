class DocumentsController < ApplicationController
  before_action :set_document, only: %i[show edit update destroy]

  def show; end

  def new
    @document = collection.documents.new
  end

  def create
    @document = collection.documents.new(create_params)
    @document.ai_extract = params[:document][:ai_extract] == '1'
    @document.processing_status = @document.ai_extract ? :pending : :not_processable

    if @document.save
      flash.now[:success] = 'Document uploaded successfully'
    else
      flash.now[:alert] = @document.errors.full_messages.to_sentence
    end
  end

  def edit; end

  def update
    @source = params[:source] || 'document'

    @document.ai_extract = params[:document][:ai_extract] == '1'
    @document.processing_status = @document.ai_extract ? :pending : :not_processable

    if @document.update(update_params)
      @document.process_ai! if @document.ai_extract?
      flash.now[:success] = 'Document updated successfully'
    else
      flash.now[:alert] = @document.errors.full_messages.to_sentence
    end
  end

  def destroy
    @document.destroy!

    respond_to do |format|
      format.turbo_stream do
        flash.now[:success] = 'Document Deleted Successfully.'
      end

      format.html do
        redirect_to collection_path(@collection), notice: 'Document Deleted Successfully.'
      end
    end
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
