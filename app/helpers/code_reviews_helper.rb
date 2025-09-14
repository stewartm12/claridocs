module CodeReviewsHelper
  def review_icon(type)
    case type
    when 'code_reviews'
      '<span class="text-2xl">🔍</span>'.html_safe
    when 'test_coverage_reviews'
      '<span class="text-2xl">🧪</span>'.html_safe
    when 'security_reviews'
      '<span class="text-2xl">🛡️</span>'.html_safe
    when 'performance_reviews'
      '<span class="text-2xl">⚡</span>'.html_safe
    else
      '<span class="text-2xl">📄</span>'.html_safe
    end
  end

  def review_type_badge(type)
    color_class = case type
    when 'code_reviews' then 'bg-blue-100 text-blue-800'
    when 'test_coverage_reviews' then 'bg-green-100 text-green-800'
    when 'security_reviews' then 'bg-red-100 text-red-800'
    when 'performance_reviews' then 'bg-yellow-100 text-yellow-800'
    else 'bg-gray-100 text-gray-800'
    end

    content_tag :span, type, class: "px-2 py-1 text-xs font-semibold rounded-full #{color_class}"
  end
end
