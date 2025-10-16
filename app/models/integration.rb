class Integration < ApplicationRecord
  has_many :user_integrations, dependent: :destroy

  validates :name, :provider, :description, :type, presence: true
  validates :name, uniqueness: true
end
