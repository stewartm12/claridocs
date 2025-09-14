require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe '#assocations' do
    it { should have_many(:sessions).dependent(:destroy) }
  end

  describe '#validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('test1@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }

    it { should validate_presence_of(:password).on(:create) }
    it { should have_secure_password }
  end

  describe '#normalizations' do
    let(:user) { create(:user, name: 'john Doe', email: ' JohnDOE@email.com ') }

    context 'name' do
      it 'titleizes the name before saving' do
        expect(user.name).to eq("John Doe")
      end
    end

    context 'email' do
      it 'downcases and strips the email before saving' do
        expect(user.email).to eq('johndoe@email.com')
      end
    end
  end

  describe '#password_complexity' do
    let(:user) { build(:user, password: 'simple', password_confirmation: 'simple') }

    context 'in non-development environments' do
      before { allow(Rails.env).to receive(:development?).and_return(false) }

      context 'when password is too simple' do
        it 'is invalid' do
          expect(user).not_to be_valid
          expect(user.errors[:password]).to include('must include at least one uppercase letter', 'must include at least one number', 'must include at least one special character', 'must be at least 11 characters long')
        end
      end

      context 'when password is complex enough' do
        before do
          user.password = 'JDoe@1965!Hurray'
          user.password_confirmation = 'JDoe@1965!Hurray'
          user.save!
        end

        it 'is valid if password meets complexity requirements' do
          expect(user).to be_valid
        end
      end
    end

    context 'in development environment' do
      before do
        allow(Rails.env).to receive(:development?).and_return(true)
        user.save!
      end

      it 'allows simple passwords' do
        expect(user).to be_valid
      end
    end
  end
end
