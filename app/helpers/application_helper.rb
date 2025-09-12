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
end
