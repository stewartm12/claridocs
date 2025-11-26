class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  default_url_options[:locale] = I18n.default_locale
end
