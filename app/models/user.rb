class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :documents, through: :collections
  has_many :user_integrations, dependent: :destroy

  validates :name, :email, presence: true
  validates :password, password_complexity: true
  validates :email, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }

  normalizes :email, with: ->(e) { e.strip.downcase }
  normalizes :name, with: ->(e) { e.titleize }

  after_create_commit :create_user_integrations

  def documents_count
    collections.sum(&:documents_count)
  end

  def active_chat_integration
    @active_chat_integration ||= user_integrations.where.not(active_chat_id: nil).first
  end

  def active_embedding_integration
    @active_embedding_integration ||= user_integrations.where.not(active_embedding_id: nil).first
  end

  def active_chat_model
    active_chat_integration&.active_chat
  end

  def active_embedding_model
    active_embedding_integration&.active_embedding
  end

  def has_access_tokens?
    [
      active_chat_integration&.access_token,
      active_embedding_integration&.access_token
    ].all?(&:present?)
  end

  def has_ai_integration?
    active_chat_integration.present? &&
    active_embedding_integration.present? &&
    has_access_tokens?
  end

  private

  def create_user_integrations
    Integration.find_each do |integration|
      user_integrations.find_or_create_by!(integration: integration)
    end
  end
end
