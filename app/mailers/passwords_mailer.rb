class PasswordsMailer < ApplicationMailer
  default_url_options[:locale] = I18n.default_locale
  def reset(user)
    @user = user
    mail subject: 'Reset your password', to: user.email
  end
end
