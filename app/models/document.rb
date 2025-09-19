class Document < ApplicationRecord
  has_one_attached :file

  belongs_to :collection, counter_cache: true

  validates :title, presence: true, uniqueness: { scope: :collection_id, case_sensitive: false }
  validate :correct_file_type

  before_validation :set_document_type_from_file, if: -> { file.attached? && document_type.nil? }

  enum :document_type, {
    misc: 0,   # fallback type
    pdf: 1,
    doc: 2,    # Word (.doc)
    docx: 3,   # Word (.docx)
    txt: 4,    # plain text
    rtf: 5,
    xls: 6,    # Excel (.xls)
    xlsx: 7,   # Excel (.xlsx)
    ppt: 8,    # PowerPoint (.ppt)
    pptx: 9,   # PowerPoint (.pptx)
    md: 10     # Markdown
  }

  # Map MIME types to these abbreviated enums
  MIME_TO_ENUM = {
    'application/pdf' => :pdf,
    'application/msword' => :doc,
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document' => :docx,
    'text/plain' => :txt,
    'application/rtf' => :rtf,
    'application/vnd.ms-excel' => :xls,
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' => :xlsx,
    'application/vnd.ms-powerpoint' => :ppt,
    'application/vnd.openxmlformats-officedocument.presentationml.presentation' => :pptx,
    'text/markdown' => :md
  }.freeze

  MEDIA_TYPES = %w[image video audio].freeze

  def size_in_mb
    (size_bytes.to_f / 1.megabyte).round(2)
  end

  def size_in_gb
    (size_bytes.to_f / 1.gigabyte).round(2)
  end

  private

  def acceptable_file_type
    return unless file.attached?

    if MEDIA_TYPES.any? { |type| file.content_type.start_with?(type) }
      errors.add(:file, 'cannot be an image, video, or audio file')
    end
  end

  def set_document_type_from_file
    self.document_type = MIME_TO_ENUM.fetch(file.content_type, :misc)
  end
end
