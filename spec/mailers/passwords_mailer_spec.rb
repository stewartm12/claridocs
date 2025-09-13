require "rails_helper"

RSpec.describe PasswordsMailer, type: :mailer do
  describe '#reset' do
    let(:user) { create(:user, email: 'test@example.com') }
    let(:mail) { described_class.reset(user) }

    it 'renders the subject' do
      expect(mail.subject).to eq('Reset your password')
    end

    it 'sends to the correct recipient' do
      expect(mail.to).to eq([user.email])
    end
  end
end
