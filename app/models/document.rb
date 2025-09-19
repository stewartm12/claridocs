class Document < ApplicationRecord
  include DocumentTypeMappings

  has_one_attached :file

  belongs_to :collection, counter_cache: true

  validates :title, presence: true, uniqueness: { scope: :collection_id, case_sensitive: false }
  validate :acceptable_file_type

  before_validation :set_file_metadata, on: :create

  MEDIA_TYPES = %w[image video audio].freeze

  private

  def acceptable_file_type
    return unless file.attached?

    if MEDIA_TYPES.any? { |type| file.content_type.start_with?(type) }
      errors.add(:file, 'cannot be an image, video, or audio file')
    end
  end

  def set_file_metadata
    return unless file.attached?

    self.document_type = self.class.from_mime(file.content_type)
    self.title = File.basename(file.filename.to_s, File.extname(file.filename.to_s))
    self.size_bytes = file.blob.byte_size
  end
end
