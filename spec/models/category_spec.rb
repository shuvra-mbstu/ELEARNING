require 'rails_helper'

RSpec.describe Category do
  let!(:category) { FactoryBot.create(:category) }

  it 'has a valid factory' do
    expect(category).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'associations' do
    it { is_expected.to have_many(:courses).dependent(:nullify) }
  end
end
