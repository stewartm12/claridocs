require 'rails_helper'

RSpec.describe CleanupExpiredSessionsJob, type: :job do
  describe '#perform' do
    it 'calls Session.cleanup_expired' do
      expect(Session).to receive(:cleanup_expired)
      described_class.perform_now
    end
  end

  describe 'queueing' do
    it 'is placed on the default queue' do
      expect(described_class.queue_name).to eq('default')
    end

    it 'enqueues correctly' do
      expect {
        described_class.perform_later
      }.to have_enqueued_job(described_class).on_queue('default')
    end
  end
end
