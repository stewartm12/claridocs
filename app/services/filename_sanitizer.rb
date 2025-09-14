class FilenameSanitizer
  VALID_SEGMENT_PATTERN = /\A[\w\-\.]+\z/
  REQUIRED_SEGMENTS = 2

  def initialize(filename)
    @filename = filename
  end

  def sanitized_filename
    return nil if invalid_filename?

    clean_path = normalized_path
    return nil unless valid_segment_count?(clean_path)
    return nil unless valid_segments?(clean_path)

    clean_path
  end

  private

  attr_reader :filename

  def invalid_filename?
    filename.blank?
  end

  def normalized_path
    Pathname.new(filename.to_s).cleanpath.to_s
  end

  def valid_segment_count?(path)
    path.split('/').size == REQUIRED_SEGMENTS
  end

  def valid_segments?(path)
    segments = path.split('/')
    segments.all? { |segment| valid_segment?(segment) }
  end

  def valid_segment?(segment)
    segment.match?(VALID_SEGMENT_PATTERN) && !segment.start_with?('.')
  end
end
