require 'rails_helper'

RSpec.describe Quality::ReviewTypeFormatter do
  describe '#display_name' do
    subject { described_class.new(input).display_name }

    context 'when review_type matches code review' do
      let(:input) { 'code_review' }

      it { is_expected.to eq('Code Review') }
    end

    context 'when review_type matches test coverage' do
      let(:input) { 'test_coverage' }

      it { is_expected.to eq('Test Coverage') }
    end

    context 'when review_type matches code review' do
      let(:input) { 'security' }

      it { is_expected.to eq('Security Review') }
    end

    context 'when review_type matches code review' do
      let(:input) { 'performance' }

      it { is_expected.to eq('Performance Review') }
    end

    context 'when review_type does not match any predefined names' do
      let(:input) { 'non_existent_name' }

      it { is_expected.to eq('Code Review') }
    end
  end
end
