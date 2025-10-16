class DocumentProcessingJob < ApplicationJob
  queue_as :default

  # retry_on StandardError, wait: :exponentially_longer, attempts: 3

  def perform(document_id:, user_id:)
    document = Document.find(document_id)
    user = User.find(user_id)

    if user.has_ai_integration?
      Document::Processing.new(document, user).call
    else
      document.update!(
        processing_status: :failed,
        extracted_metadata: { error: 'No active AI integration', failed_at: Time.current }
      )
    end
  end
end
