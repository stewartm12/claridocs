class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  add_flash_types :success

  def redirect_signed_in_user
    return unless authenticated?

    redirect_back(fallback_location: after_authentication_url)
  end
end
