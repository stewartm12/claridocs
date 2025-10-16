class AiIntegration < Integration
  has_many :ai_models

  enum :provider, {
    open_ai: 'OpenAI',
    deep_seek: 'Deepseek'
  }
end
