require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  let(:user) { create(:user) }
  let(:session) { create(:session, user: user) }

  context 'without a valid session' do
    it 'rejects connection' do
      expect {
        connect '/cable'
      }.to raise_error(ActionCable::Connection::Authorization::UnauthorizedError)
    end
  end

  context 'with a valid session' do
    before do
      cookies.signed[:session_id] = session.id
      connect '/cable'
    end

    it 'accepts connection' do
      expect(connection.current_user).to eq(user)
    end
  end
end
