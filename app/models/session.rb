class Session < ApplicationRecord
  belongs_to :user

  before_create :set_expiration

  scope :active, -> { where('expires_at > ?', Time.current) }
  scope :expired, -> { where('expires_at <= ?', Time.current) }

  DEFAULT_SESSION_DURATION = 1.day.freeze
  REMEMBER_ME_DURATION = 30.days.freeze
  MAX_REMEMBER_ME_DURATION = 90.days.freeze

  def self.cleanup_expired
    expired.destroy_all
  end

  def expired?
    expires_at <= Time.current
  end

  def remember_token_expired?
    remember_token_expires_at && remember_token_expires_at <= Time.current
  end

  def extend_expiration!
    update!(expires_at: DEFAULT_SESSION_DURATION.from_now)
  end

  def extend_remember_token!
    new_expires_at = [REMEMBER_ME_DURATION.from_now, created_at + MAX_REMEMBER_ME_DURATION].min

    update!(
      remember_token: SecureRandom.base58(32),
      remember_token_expires_at: new_expires_at
    )
  end

  private

  def set_expiration
    self.expires_at ||= DEFAULT_SESSION_DURATION.from_now
  end
end
