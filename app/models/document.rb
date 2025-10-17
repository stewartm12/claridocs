class Document < ApplicationRecord
  include DocumentTypeMappings

  has_one_attached :file

  belongs_to :collection, counter_cache: true
  has_one :user, through: :collection
  has_many :document_chunks, dependent: :destroy

  validates :title, presence: true, uniqueness: { scope: :collection_id, case_sensitive: false }
  validate :acceptable_file_type

  before_validation :set_file_metadata, on: :create

  after_create_commit :process_document_async
  # after_update_commit :process_document_async

  INVALID_MEDIA_TYPES = %w[image video audio].freeze

  enum :processing_status, {
    pending: 0,
    processing: 1,
    completed: 2,
    failed: 3,
    needs_reprocessing: 4,
    skipped: 5
  }

  scope :processed, -> { where(processing_status: :completed) }
  scope :ready_for_processing, -> { where(processing_status: %i[pending needs_reprocessing]) }
  scope :skipped, -> { where(processing_status: :skipped) }

  def apply_ai_extract!(flag)
    self.ai_extract = flag
    self.processing_status = ai_extract? ? :pending : :skipped
  end

  def process_ai!
    process_document_async
  end

  private

  def acceptable_file_type
    return unless file.attached?

    if INVALID_MEDIA_TYPES.any? { |type| file.content_type.start_with?(type) }
      errors.add(:file, 'cannot be an image, video, or audio file')
    end
  end

  def set_file_metadata
    return unless file.attached?

    self.document_type = self.class.from_mime(file.content_type)
    self.title = File.basename(file.filename.to_s, File.extname(file.filename.to_s))
    self.size_bytes = file.blob.byte_size
  end

  def process_document_async
    setup_pages_count
    return unless ai_extract? && processed_at.nil?

    if user.has_ai_integration?
      DocumentProcessingJob.perform_later(document_id: id, user_id: user.id)
    else
      update!(
        processing_status: :failed,
        ai_extract: false,
        extracted_metadata: { error: 'No active AI integration', failed_at: Time.current }
      )
    end
  end

  def setup_pages_count
    return unless file.attached? && file.content_type == 'application/pdf'

    reader = PDF::Reader.new(StringIO.new(file.download))
    update!(page_count: reader.page_count)
  end

  def calculate_content_hash
    return nil unless file.attached?

    Digest::SHA256.hexdigest(file.download)
  end
end
