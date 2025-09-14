class ReviewFile
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :path, :string
  attribute :type, :string

  def self.find_by_filename(filename)
    sanitized = FilenameSanitizer.new(filename).sanitized_filename
    return nil unless sanitized

    file_path = build_file_path(sanitized)
    return nil unless valid_file_path?(file_path)

    new(path: file_path, type: extract_type_from_path(file_path))
  end

  def filename
    File.basename(path, '.md')
  end

  def branch_name
    filename.split('_').first
  end

  def date
    File.mtime(path)
  end

  def content
    File.read(path)
  end

  def display_type
    ReviewTypeFormatter.new(type).display_name
  end

  private

  def self.build_file_path(filename)
    type, branch = filename.split('/')
    return nil unless ReviewFileFinder::ALLOWED_TYPES.include?(type)

    Rails.root.join('reviews', type, "#{branch}.md")
  end

  def self.valid_file_path?(file_path)
    File.exist?(file_path) && SecurityValidator.new(file_path).within_reviews_directory?
  end

  def self.extract_type_from_path(file_path)
    file_path.to_s.split('/')[-2]
  end
end
