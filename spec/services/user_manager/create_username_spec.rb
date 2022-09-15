require 'rails_helper'

RSpec.describe UserManager::CreateUsername do
  let(:context) { UserManager::CreateUsername.call(params: params) }

  describe '#call' do
    context 'when given valid params' do
      let(:params) { { full_name: 'David Hansson' } }

      it 'is marked as successfull' do
        expect(context.success?).to eq(true)
      end

      it 'provides the username' do
        expect(context.username).to eq('david_hansson')
      end
    end

    context 'when given invalid params' do
      let(:params) { { full_name: '' } }

      it 'does not raise error' do
        expect(context.error).to be_nil
      end

      it 'provides a random username' do
        expect(context.username).to be_present
      end
    end
  end
end
