class DocumentProcessingJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: :exponentially_longer, attempts: 3

  def perform(document_id)
    document = Document.find(document_id)
    Document::Processing.new(document).call
  end
end
