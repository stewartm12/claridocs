class SecurityValidator
  def initialize(file_path)
    @file_path = file_path
  end

  def within_reviews_directory?
    file_realpath.to_s.start_with?(reviews_root.to_s)
  rescue Errno::ENOENT
    false
  end

  private

  attr_reader :file_path

  def reviews_root
    @reviews_root ||= Rails.root.join('reviews').realpath
  end

  def file_realpath
    @file_realpath ||= Pathname.new(file_path).realpath
  end
end
