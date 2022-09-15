require 'rails_helper'

RSpec.shared_examples 'Category Access Denied Examples' do
  it 'redirects to root path' do
    expect(response).to redirect_to root_path
  end

  it 'sets a flash message' do
    expect(flash[:danger]).to eq('Access denied!')
  end
end
