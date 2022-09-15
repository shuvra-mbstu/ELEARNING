require 'rails_helper'

RSpec.describe UsersController do
  let(:user_1) { FactoryBot.create(:user) }
  let(:user_2) { FactoryBot.create(:user) }
  let(:invalid_id) { 1_234_567 }

  before { login_as user_1 }

  describe 'GET #index' do
    before do
      user_1
      user_2
      get :index
    end

    it 'populates an array of users' do
      expect(assigns(:users)).to match_array([user_1, user_2])
    end

    it 'renders :index template' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    context 'with valid attributes' do
      let(:course_1) { FactoryBot.create(:course, author: user_1) }
      let(:course_2) { FactoryBot.create(:course) }
      let(:create_enrollement) { FactoryBot.create(:enrollment, user: user_1, course: course_2) }

      before { get :show, params: { id: user_1.id } }

      it 'assigns the requested user to @user' do
        expect(assigns(:user)).to eq(user_1)
      end

      it 'populates an array of courses to @taught_courses' do
        expect(assigns(:taught_courses)).to match_array(course_1)
      end

      it 'populates an array of courses to @enrolled_courses' do
        create_enrollement

        expect(assigns(:enrolled_courses)).to match_array(course_2)
      end

      it 'renders :show template' do
        expect(response).to render_template :show
      end
    end

    context 'with invalid attributes' do
      before { get :show, params: { id: invalid_id } }

      it 'rendirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'sets a flash message' do
        expect(flash[:danger]).to eq(I18n.t('notice.record_not_found',
                                            resource: User.model_name.human,
                                            id: invalid_id))
      end
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns @user as a new record' do
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'renders :new template' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    context 'when accessing own profile' do
      before { get :edit, params: { id: user_1.id } }

      it 'assigns the requested user to @user' do
        expect(assigns(:user)).to eq(user_1)
      end

      it 'renders :edit template' do
        expect(response).to render_template :edit
      end
    end

    context 'when accessing other users profile' do
      before { get :edit, params: { id: user_2.id } }

      it 'rendirect to root path' do
        expect(response).to redirect_to root_path
      end

      it 'sets a flash message' do
        expect(flash[:danger]).to eq(I18n.t('notice.user_not_authorized'))
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:valid_user_params) { { user: FactoryBot.attributes_for(:user) } }
      let(:perform_post) { post :create, params: valid_user_params }

      it 'saves a new user in database' do
        expect { perform_post }.to change(User, :count).by(1)
      end

      it 'redirects to login path' do
        perform_post

        expect(response).to redirect_to login_path
      end
    end

    context 'with invalid attributes' do
      let(:invalid_user_params) { { user: { password: 'short' } } }
      let(:perform_post) { post :create, params: invalid_user_params }

      it 'does not save the user' do
        expect { perform_post }.to change(User, :count).by(0)
      end

      it 'renders :new template' do
        perform_post

        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes ' do
      let(:valid_update_params) { FactoryBot.attributes_for(:user, full_name: 'New Name') }

      before do
        patch :update, params: { user: valid_update_params, id: user_1.id }
        user_1.reload
      end

      it 'updates the user attributes' do
        expect(user_1.full_name).to eq('New Name')
      end

      it 'redirects to user path' do
        expect(response).to redirect_to user_1
      end
    end

    context 'with invalid attributes' do
      let(:invalid_update_params) { FactoryBot.attributes_for(:user, full_name: nil) }

      before do
        patch :update, params: { user: invalid_update_params, id: user_1.id }
        user_1.reload
      end

      it 'fails to update user attributes' do
        expect(user_1.full_name).to_not be_nil
      end

      it 'renders :edit template' do
        expect(response).to render_template :edit
      end

      it 'has :bad_request http status' do
        expect(response).to have_http_status :bad_request
      end
    end
  end

  describe 'User #destroy' do
    context 'with valid attributes' do
      let(:perform_delete) { delete :destroy, params: { id: user_1.id } }

      before { user_1 }

      it 'deletes the user from database' do
        expect { perform_delete }.to change(User, :count).by(-1)
      end

      it 'redirects to root path' do
        perform_delete

        expect(response).to redirect_to root_path
      end
    end

    context 'with invalid attributes' do
      let(:perform_delete) { delete :destroy, params: { id: invalid_id } }

      before { user_1 }

      it 'does not change users database' do
        expect { perform_delete }.to change(User, :count).by(0)
      end

      it 'redirects to root path' do
        perform_delete

        expect(response).to redirect_to root_path
      end
    end
  end
end
