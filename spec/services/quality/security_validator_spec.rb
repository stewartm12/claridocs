require 'rails_helper'

RSpec.describe Quality::SecurityValidator do
  let(:reviews_root) { Pathname.new('/app/reviews') }

  before do
    allow(Rails).to receive(:root).and_return(Pathname.new('/app'))
    allow_any_instance_of(Pathname).to receive(:realpath) { |path| path }
  end

  describe '#within_reviews_directory?' do
    subject(:validator) { described_class.new(file_path) }

    context 'when file is inside the reviews directory' do
      let(:file_path) { '/app/reviews/security/file.txt' }

      it 'returns true' do
        expect(validator.within_reviews_directory?).to be true
      end
    end

    context 'when file is outside the reviews directory' do
      let(:file_path) { '/app/other_dir/file.txt' }

      it 'returns false' do
        expect(validator.within_reviews_directory?).to be false
      end
    end

    context 'when file does not exist' do
      let(:file_path) { '/app/reviews/missing.txt' }

      before do
        allow(Pathname).to receive(:new).and_call_original
        allow_any_instance_of(Pathname).to receive(:realpath)
          .and_raise(Errno::ENOENT)
      end

      it 'returns false' do
        expect(validator.within_reviews_directory?).to be false
      end
    end
  end
end
