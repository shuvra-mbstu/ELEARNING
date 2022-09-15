require 'rails_helper'

RSpec.describe Course do
  subject(:course) { FactoryBot.create(:course) }

  it 'it has a valid factory' do
    expect(course).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:credit_hour) }
    it { is_expected.to validate_uniqueness_of(:title) }
    it { is_expected.to validate_numericality_of(:credit_hour) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:category).optional }
    it { is_expected.to belong_to(:author).class_name('User').with_foreign_key('author_id') }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:enrollments).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:enrollments) }
  end
end
