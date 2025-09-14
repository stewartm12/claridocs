class ReviewFileFinder
  ALLOWED_TYPES = %w[
    code_reviews
    performance_reviews
    security_reviews
    test_coverage_reviews
  ].freeze

  def grouped_reviews
    ALLOWED_TYPES.each_with_object({}) do |type, reviews|
      reviews[type] = review_files_for_type(type)
    end
  end

  private

  def review_files_for_type(type)
    return [] unless review_directory_exists?(type)

    markdown_files_in(type)
      .map { |path| ReviewFile.new(path: path, type: type) }
      .sort_by(&:date)
      .reverse
  end

  def review_directory_exists?(type)
    Dir.exist?(Rails.root.join('reviews', type))
  end

  def markdown_files_in(type)
    Dir.glob(Rails.root.join('reviews', type, '*.md'))
  end
end
