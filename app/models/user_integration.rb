class UserIntegration < ApplicationRecord
  belongs_to :user
  belongs_to :integration

  # Only utilized when the integration is an AiIntegration
  belongs_to :active_chat, class_name: 'AiModel', optional: true
  belongs_to :active_embedding, class_name: 'AiModel', optional: true

  validates :user_id, uniqueness: { scope: :integration_id, message: 'already has this integration' }

  def disconnect!
    update(
      active_chat: nil,
      active_embedding: nil,
      access_token: nil,
      refresh_token: nil,
      token_expires_at: nil,
      username: nil,
      connected_at: nil
    )
  end
end
