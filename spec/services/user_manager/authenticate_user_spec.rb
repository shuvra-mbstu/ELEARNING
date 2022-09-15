require 'rails_helper'

RSpec.describe UserManager::AuthenticateUser do
  let(:context) { UserManager::AuthenticateUser.call(session_params) }

  describe '#call' do
    context 'when given valid credentials' do
      let(:session_params) { { email: 'imamhossain@gmail.com', password: 'secret' } }
      let!(:user) { FactoryBot.create(:user, session_params) }

      it 'is marked as successfull' do
        expect(context.success?).to eq(true)
      end

      it 'provides the user' do
        expect(context.user).to eq(user)
      end
    end

    context 'when given invalid credentials' do
      let!(:user) { FactoryBot.create(:user) }
      let(:session_params) { { email: 'imamhossain@gmail.com', password: '123456' } }

      it 'is marked as unsuccessful' do
        expect(context.success?).to eq(false)
      end

      it 'provides a failure message' do
        expect(context.message).to be_present
      end
    end
  end
end
