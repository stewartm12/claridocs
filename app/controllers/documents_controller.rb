class DocumentsController < ApplicationController
  before_action :set_document, only: %i[show edit update destroy]

  def show; end

  def new
    @document = collection.documents.new
  end

  def create
    @document = collection.documents.new(create_params)
    @document.apply_ai_extract!(ai_extract_param)

    if @document.save
      flash.now[:success] = 'Document uploaded successfully'
    else
      flash.now[:alert] = @document.errors.full_messages.to_sentence
    end
  end

  def edit; end

  def update
    @source = params[:source] || 'document'
    @document.apply_ai_extract!(ai_extract_param)

    if @document.update(update_params)
      @document.process_ai! if @document.ai_extract?
      flash.now[:success] = 'Document updated successfully'
    else
      flash.now[:alert] = @document.errors.full_messages.to_sentence
    end
  end

  def destroy
    @source = params[:source] || 'document'
    @document.destroy!

    if @source == 'document'
      redirect_to collection_path(@collection), notice: 'Document Deleted Successfully.' and return
    else
      flash.now[:success] = 'Document Deleted Successfully.'
    end
  end

  private

  def create_params
    params.expect(document: %i[description file])
  end

  def update_params
    params.expect(document: %i[title description])
  end

  def ai_extract_param
    params[:document][:ai_extract] == '1'
  end

  def collection
    @collection ||= current_user.collections.find(params[:collection_id])
  end

  def set_document
    @document = collection.documents.find(params[:id])
  end
end
