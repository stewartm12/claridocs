require 'rails_helper'

RSpec.describe ApplicationRecord, type: :model do
  it 'inherits from ActiveRecord::Base' do
    expect(ApplicationRecord < ActiveRecord::Base).to be true
  end

  it 'is an abstract class' do
    expect(ApplicationRecord.abstract_class).to be true
  end
end
