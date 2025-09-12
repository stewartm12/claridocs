class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email, with: ->(e) { e.strip.downcase }

  validate :password_complexity

  private

  def password_complexity
    unless password.match?(/(?=.*[a-z])/)
      errors.add :password, 'must include at least one lowercase letter'
    end

    unless password.match?(/(?=.*[A-Z])/)
      errors.add :password, 'must include at least one uppercase letter'
    end

    unless password.match?(/(?=.*\d)/)
      errors.add :password, 'must include at least one number'
    end

    unless password.match?(/(?=.*[^A-Za-z0-9])/)
      errors.add :password, 'must include at least one special character'
    end

    unless password.length >= 11
      errors.add :password, 'must be at least 11 characters long'
    end
  end
end
