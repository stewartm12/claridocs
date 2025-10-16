class AiModel < ApplicationRecord
  belongs_to :ai_integration, class_name: 'AiIntegration', foreign_key: 'ai_integration_id'

  validates :provider, :name, :description, :category, presence: true

  enum :category, { chat: 'Chat', embedding: 'Embedding' }
  enum :provider, { open_ai: 'OpenAI', deep_seek: 'Deepseek' }
  enum :name, {
    'gpt-5': 'GPT-5',
    'gpt-5-nano': 'GPT-5 Nano',
    'gpt-5-mini': 'GPT-5 Mini',
    'gpt-4.1': 'GPT-4.1',
    'text-embedding-3-small': 'text-embedding-3-small'
  }
end
