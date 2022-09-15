require 'rails_helper'

RSpec.describe Comment do
  subject(:comment) { FactoryBot.create(:comment) }

  it 'it has a valid factory' do
    expect(comment).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user).class_name('User') }
    it { is_expected.to belong_to(:course).class_name('Course') }
  end
end
