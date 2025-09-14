class ReviewTypeFormatter
  TYPE_MAPPINGS = {
    /code_review/i => 'Code Review',
    /test_coverage/i => 'Test Coverage',
    /security/i => 'Security Review',
    /performance/i => 'Performance Review'
  }.freeze

  DEFAULT_TYPE = 'Code Review'

  def initialize(review_type)
    @review_type = review_type
  end

  def display_name
    TYPE_MAPPINGS.each do |pattern, display_name|
      return display_name if review_type.match?(pattern)
    end

    DEFAULT_TYPE
  end

  private

  attr_reader :review_type
end
