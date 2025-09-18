require 'rails_helper'

RSpec.describe Session, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'callbacks' do
    context '#set_expiration' do
      let(:session) { build(:session) }

      it 'sets expires_at before creation' do
        session.save!

        expect(session.expires_at).to be_present
      end
    end
  end

  describe 'scopes' do
    let(:active_session) { create(:session, expires_at: 1.hour.from_now) }
    let(:expired_session) { create(:session, expires_at: 1.hour.ago) }

    context '.active' do
      it 'returns only active sessions' do
        expect(Session.active).to include(active_session)
        expect(Session.active).not_to include(expired_session)
      end
    end

    context '.expired' do
      it 'returns only expired sessions' do
        expect(Session.expired).to include(expired_session)
        expect(Session.expired).not_to include(active_session)
      end
    end
  end

  describe '.cleanup_expired' do
    let!(:active_session) { create(:session, expires_at: 1.hour.from_now) }
    let!(:expired_session) { create(:session, expires_at: 1.hour.ago) }

    it 'deletes expired sessions' do
      expect { Session.cleanup_expired }.to change { Session.count }.by(-1)
      expect(Session.exists?(expired_session.id)).to be_falsey
      expect(Session.exists?(active_session.id)).to be_truthy
    end
  end

  describe '#expired?' do
    let(:session) { build(:session, expires_at: expires_at) }

    context 'when session is expired' do
      let(:expires_at) { 1.hour.ago }

      it 'returns true' do
        expect(session.expired?).to be_truthy
      end
    end

    context 'when session is active' do
      let(:expires_at) { 1.hour.from_now }

      it 'returns false' do
        expect(session.expired?).to be_falsey
      end
    end
  end

  describe '#remember_token_expired?' do
    let(:session) { build(:session, remember_token_expires_at: remember_token_expires_at) }

    context 'when remember token is expired' do
      let(:remember_token_expires_at) { 1.hour.ago }

      it 'returns true' do
        expect(session.remember_token_expired?).to be_truthy
      end
    end

    context 'when remember token is active' do
      let(:remember_token_expires_at) { 1.hour.from_now }

      it 'returns false' do
        expect(session.remember_token_expired?).to be_falsey
      end
    end

    context 'when remember token expires at is nil' do
      let(:remember_token_expires_at) { nil }

      it 'returns false' do
        expect(session.remember_token_expired?).to be_falsey
      end
    end
  end

  describe '#extend_expiration!' do
    let(:session) { create(:session, expires_at: 1.hour.from_now) }
    let!(:old_expires_at) { session.expires_at }

    before { session.extend_expiration! }

    it 'extends the session expiration' do
      expect(session.expires_at).to be > old_expires_at
    end
  end

  describe '@extend_remember_token!' do
    let(:session) { create(:session, created_at: 10.days.ago, remember_token_expires_at: 1.hour.ago) }
    let!(:old_token) { session.remember_token }
    let!(:old_expires_at) { session.remember_token_expires_at }

    before { session.extend_remember_token! }

    it 'extends the remember token and its expiration' do
      expect(session.remember_token).not_to eq(old_token)
      expect(session.remember_token_expires_at).to be > old_expires_at
    end
  end
end
