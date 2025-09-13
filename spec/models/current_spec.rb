require 'rails_helper'

RSpec.describe Current do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }

  before do
    Current.reset
    Current.session = session
  end

  after do
    Current.reset
  end

  describe '.session' do
    it 'returns the current session' do
      expect(Current.session).to eq(session)
    end
  end

  describe '.user' do
    it 'delegates to session.user' do
      expect(Current.user).to eq(user)
    end

    context 'when session is nil' do
      before { Current.session = nil }

      it 'returns nil for user' do
        expect(Current.user).to be_nil
      end
    end
  end
end
