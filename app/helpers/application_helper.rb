module ApplicationHelper
  def render_flash_stream
    turbo_stream.update 'flash', partial: 'shared/flash_messages'
  end

  def flash_css_class(type)
    case type.to_sym
    when :notice then { container: 'bg-yellow-100 border-yellow-500 text-yellow-700', bar: 'bg-yellow-500' }
    when :alert  then { container: 'bg-red-100 border-red-500 text-red-700', bar: 'bg-red-500' }
    when :success then { container: 'bg-green-100 border-green-500 text-green-700', bar: 'bg-green-500' }
    else { container: 'bg-gray-100 border-gray-500 text-gray-700', bar: 'bg-gray-500' }
    end
  end

  DOC_TYPE_COLORS = {
    pdf:  %i[bg-red-100 text-red-600],
    doc:  %i[bg-blue-100 text-blue-600],
    docx: %i[bg-blue-100 text-blue-600],
    txt:  %i[bg-gray-100 text-gray-600],
    rtf:  %i[bg-purple-100 text-purple-600],
    xls:  %i[bg-green-100 text-green-600],
    xlsx: %i[bg-green-100 text-green-600],
    ppt:  %i[bg-orange-100 text-orange-600],
    pptx: %i[bg-orange-100 text-orange-600],
    md:   %i[bg-yellow-100 text-yellow-600]
  }.freeze

  def document_color_classes(mime_type)
    doc_color = DOC_TYPE_COLORS[mime_type.to_sym] || %i[bg-gray-100 text-gray-600]
    doc_color.join(' ')
  end

  def nav_link_to(name = nil, options = nil, html_options = nil, &block)
    active_class = current_page?(name) ? 'bg-emerald-50 text-emerald-700 border-l-2 border-r-2 border-emerald-600' : 'text-gray-600 hover:text-emerald-600 hover:bg-gray-50'
    options[:class] = "#{options[:class]} #{active_class}".strip
    link_to(name, options, html_options, &block)
  end

  def show_authenticated_navbar?
    authenticated? && !request.path.start_with?('/code_qualities')
  end

  def time_since_updated(record)
    distance = time_ago_in_words(record.updated_at)
    "#{distance} ago"
  end
end
