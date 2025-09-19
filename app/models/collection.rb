class Collection < ApplicationRecord
  belongs_to :user, counter_cache: true

  has_many :documents, dependent: :destroy

  validates :title, presence: true, uniqueness: { scope: :user_id, case_sensitive: false }

  def total_bytes
    documents.sum(&:size_bytes)
  end
end
