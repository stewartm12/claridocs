require 'rails_helper'

RSpec.describe ReviewFile, type: :model do
  describe 'attributes' do
    let(:file) { described_class.new(path: '/some/path.md', type: 'markdown') }

    context 'with attributes present' do
      it 'can set and get path' do
        expect(file.path).to eq('/some/path.md')
      end

      it 'can set and get type' do
        expect(file.type).to eq('markdown')
      end
    end

    context 'when attributes are missing' do
      let(:file) { described_class.new }

      it 'defaults to nil if not set' do
        expect(file.path).to be_nil
        expect(file.type).to be_nil
      end
    end
  end

  let(:filename) { 'code_reviews/feature-branch_2025-09-17' }
  let(:sanitized_filename) { filename }
  let(:file_path) { Rails.root.join('reviews', 'code_reviews', 'feature-branch_2025-09-17.md') }
  let(:file_content) { "# Markdown Review Content" }
  let(:sanitizer) { instance_double(Quality::FilenameSanitizer, sanitized_filename: sanitized_filename) }
  let(:security_validator) { instance_double(Quality::SecurityValidator, within_reviews_directory?: true) }

  before do
    allow(Quality::FilenameSanitizer).to receive(:new).with(filename).and_return(sanitizer)
    allow(Quality::SecurityValidator).to receive(:new).and_return(security_validator)
    allow(File).to receive(:exist?).and_return(true)
    allow(File).to receive(:read).and_return(file_content)
    allow(File).to receive(:mtime).and_return(Time.parse('2025-09-17 12:00:00'))
  end

  describe '.find_by_filename' do
    let(:searched_file) { described_class.find_by_filename(filename) }

    context 'when sanitized filename is nil' do
      let(:sanitized_filename) { nil }

      it 'returns nil' do
        expect(searched_file).to be_nil
      end
    end

    context 'when file does not exist' do
      before { allow(File).to receive(:exist?).and_return(false) }

      it 'returns nil' do
        expect(searched_file).to be_nil
      end
    end

    context 'when file exists and is valid' do
      it 'returns a ReviewFile with correct attributes' do
        expect(searched_file).to be_a(described_class)
        expect(searched_file.path).to eq(file_path.to_s)
        expect(searched_file.type).to eq('code_reviews')
      end
    end
  end

  describe '#filename' do
    let(:review_file) { described_class.new(path: file_path, type: 'code_reviews') }

    it 'returns the file name without extension' do
      expect(review_file.filename).to eq('feature-branch_2025-09-17')
    end
  end

  describe '#branch_name' do
    let(:review_file) { described_class.new(path: file_path, type: 'code_reviews') }

    it 'returns the first part of the filename' do
      expect(review_file.branch_name).to eq('feature-branch')
    end
  end

  describe '#date' do
    let(:review_file) { described_class.new(path: file_path, type: 'code_reviews') }

    it 'returns the file modified time' do
      expect(review_file.date).to eq(Time.parse('2025-09-17 12:00:00'))
    end
  end

  describe '#content' do
    let(:review_file) { described_class.new(path: file_path, type: 'code_reviews') }

    it 'returns the file content' do
      expect(review_file.content).to eq(file_content)
    end
  end

  describe '#display_type' do
    let(:formatter) { instance_double(Quality::ReviewTypeFormatter, display_name: 'Code Reviews') }
    let(:review_file) { described_class.new(path: file_path, type: 'code_reviews') }

    before do
      allow(Quality::ReviewTypeFormatter).to receive(:new).with('code_reviews').and_return(formatter)
    end

    it 'delegates to Quality::ReviewTypeFormatter' do
      expect(review_file.display_type).to eq('Code Reviews')
    end
  end
end
