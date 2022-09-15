require 'rails_helper'

RSpec.describe UserManager::CreateUser do
  let(:context) { UserManager::CreateUser.call(params: params, username: 'david') }

  describe '#call' do
    context 'when given valid params' do
      let(:params) { FactoryBot.attributes_for(:user) }

      it 'is marked as successful' do
        expect(context.success?).to be(true)
      end

      it 'provides a valid user' do
        expect(context.user).to be_valid
      end

      it 'updates the user database' do
        expect { context }.to change(User, :count).by(1)
      end
    end

    context 'when given invalid params' do
      let(:params) { { full_name: '' } }

      it 'is marked as unsuccessful' do
        expect(context.success?).to eq(false)
      end

      it 'does not update user database' do
        expect { context }.to change(User, :count).by(0)
      end

      it 'provides a failure message' do
        expect(context.message).to be_present
      end
    end
  end
end
