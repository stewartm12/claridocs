require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  describe 'defaults' do
    let(:mail) { ApplicationMailer.new }
    it 'sets the default from address' do
      expect(mail.class.default[:from]).to eq('from@example.com')
    end
  end
end
