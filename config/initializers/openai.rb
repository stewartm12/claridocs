OpenAI.configure do |config|
  config.access_token = ENV['OPENAI_API_KEY']
  config.log_errors = true
end
