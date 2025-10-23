class PasswordComplexityValidator < ActiveModel::EachValidator
  RULES = {
    /[a-z]/ => 'must include at least one lowercase letter',
    /[A-Z]/ => 'must include at least one uppercase letter',
    /\d/ => 'must include at least one number',
    /[^A-Za-z0-9]/ => 'must include at least one special character'
  }.freeze

  def validate_each(record, attribute, value)
    return if value.blank?

    RULES.each do |regex, message|
      record.errors.add(attribute, message) unless value =~ regex
    end

    record.errors.add(attribute, 'must be at least 11 characters long') if value.length < 11
  end
end
