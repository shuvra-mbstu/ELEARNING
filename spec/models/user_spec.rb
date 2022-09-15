require 'rails_helper'

RSpec.describe User do
  let(:user) { FactoryBot.create(:user) }

  it 'has a valid factory' do
    expect(user).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:full_name) }
    it { is_expected.to have_secure_password }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
    it { is_expected.to validate_presence_of(:email) }
  end

  describe 'email validation' do
    it { is_expected.not_to allow_value('invalid@something').for(:email) }
    it { is_expected.to allow_value('something+alias-address@example.org').for(:email) }
    it { is_expected.to allow_value('valid@email.com').for(:email) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:enrollments).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:enrolled_courses).through(:enrollments).source(:course) }
    it {
      is_expected.to have_many(:taught_courses).
        class_name('Course').with_foreign_key('author_id').dependent(:destroy)
    }
  end

  describe '#remember' do
    it 'generates remember_token value' do
      user.remember
      expect(user.remember_token).to be_present
    end

    it 'saves a remeber_digest on user database' do
      expect { user.remember }.to change(user, :remember_digest).from(nil).to be_truthy
    end
  end

  describe '#authenticated?' do
    before { user.remember }

    it 'returns true for valid remember_token' do
      expect(user.authenticated?(user.remember_token)).to be_truthy
    end

    it 'returns false for invalid remember_token' do
      remember_token = SecureRandom.urlsafe_base64
      expect(user.authenticated?(remember_token)).to be_falsy
    end
  end

  describe '#forget' do
    it 'sets remember_digest nil' do
      user.forget
      expect(user.remember_digest).to be_nil
    end
  end
end
