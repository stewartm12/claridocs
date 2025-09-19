class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :documents, through: :collections

  validates :name, :email, presence: true
  validates :password, password_complexity: true, allow_nil: true, if: -> { !Rails.env.development? }
  validates :email, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }

  normalizes :email, with: ->(e) { e.strip.downcase }
  normalizes :name, with: ->(e) { e.titleize }

  def documents_count
    collections.sum(&:documents_count)
  end
end
