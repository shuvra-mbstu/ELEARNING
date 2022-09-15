require 'rails_helper'

RSpec.describe CoursesController do
  let(:user) { FactoryBot.create(:user) }
  let(:course_1) { FactoryBot.create(:course, author: user) }
  let(:course_2) { FactoryBot.create(:course, title: 'Web Development') }
  let(:invalid_id) { 1_234_567 }

  before { login_as user }

  describe 'Get #index' do
    context 'when viewing courses page' do
      before do
        course_1
        course_2
        get :index
      end

      it 'populates an array of courses' do
        expect(assigns(:courses)).to match_array([course_1, course_2])
      end

      it 'renders :index template' do
        expect(response).to render_template :index
      end
    end

    context 'when searching' do
      before do
        get :index, params: { search: { query: 'web' } }
      end

      it 'renders :index template' do
        expect(response).to render_template :search
      end

      it 'populates an array of courses to @courses' do
        expect(assigns(:courses)).to eq([course_2])
      end
    end
  end

  describe 'Get #show' do
    context 'with valid attributes' do
      before { get :show, params: { id: course_1.id } }

      it 'assigns the requested course to @course' do
        expect(assigns(:course)).to eq(course_1)
      end

      it 'renders the :show template' do
        expect(response).to render_template :show
      end
    end

    context 'with invalid attributes' do
      before { get :show, params: { id: invalid_id } }

      it 'redirect to courses path' do
        expect(response).to redirect_to courses_path
      end

      it 'sets a flash message' do
        expect(flash[:danger]).to eq(I18n.t('notice.record_not_found',
                                            resource: humanize(Course),
                                            id: invalid_id))
      end
    end
  end

  describe 'GET #new' do
    before { get :new, params: { user_id: user.id } }

    it 'assigns a new course to course' do
      expect(assigns(:course)).to be_a_new(Course)
    end

    it 'renders :new template' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    context 'when accessing own course' do
      let(:valid_params) do
        {
          user_id: user.id,
          id: course_1.id,
        }
      end
      before { get :edit, params: valid_params }

      it 'assigns the requested course to course' do
        expect(assigns(:course)).to eq(course_1)
      end

      it 'renders the :edit template' do
        expect(response).to render_template :edit
      end
    end

    context "when accessing other user's courses" do
      let(:invalid_params) do
        {
          user_id: user.id,
          id: course_2.id,
        }
      end
      before { get :edit, params: invalid_params }

      it 'renders courses path' do
        expect(response).to redirect_to courses_path
      end

      it 'sets a flash message' do
        expect(flash[:danger]).to eq(I18n.t('notice.record_not_found',
                                            resource: humanize(Course),
                                            id: course_2.id))
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:course) { FactoryBot.attributes_for(:course) }
      let(:valid_params) do
        {
          user_id: user.id,
          course: course,
        }
      end
      let(:perform_create) { post :create, params: valid_params }

      it 'saves a new course in database' do
        expect { perform_create }.to change(Course, :count).by(1)
      end

      it 'sets a flash message' do
        perform_create

        expect(flash[:success]).to eq(I18n.t('notice.create.success',
                                             resource: humanize(Course)))
      end

      it 'redirects to course path' do
        perform_create

        expect(response).to redirect_to courses_path
      end
    end

    context 'with invalid attributes' do
      let(:course) { FactoryBot.attributes_for(:course, credit_hour: 'invalid') }
      let(:invalid_params) do
        {
          user_id: user.id,
          course: course,
        }
      end
      let(:perform_create) { post :create, params: invalid_params }

      it 'does not save the course in the Database' do
        expect { perform_create }.to change(Course, :count).by(0)
      end

      it 'renders :new template' do
        perform_create

        expect(response).to render_template :new
      end

      it 'has :forbidden http status' do
        perform_create

        expect(response).to have_http_status :bad_request
      end

      it 'sets a flash message' do
        perform_create

        expect(flash[:danger]).to eq(I18n.t('notice.create.failure',
                                            resource: humanize(Course)))
      end
    end
  end

  describe 'POST #enroll' do
    context 'with valid attributes' do
      let(:valid_params) do
        {
          user_id: user.id,
          id: course_1.id,
        }
      end

      let(:perform_create) { post :enroll, params: valid_params }

      it 'saves a new enrollment in database' do
        expect { perform_create }.to change(Enrollment, :count).by(1)
      end

      it 'sets a flash message' do
        perform_create

        expect(flash[:success]).to eq(I18n.t('notice.enroll.success'))
      end

      it 'redirects to courses path' do
        perform_create

        expect(response).to redirect_to courses_path
      end
    end

    context 'with invalid attributes' do
      let(:invalid_params) do
        {
          user_id: user.id,
          id: invalid_id,
        }
      end
      let(:perform_create) { post :enroll, params: invalid_params }

      it 'does not save the course in the Database' do
        expect { perform_create }.to change(Enrollment, :count).by(0)
      end

      it 'redirects to courses path' do
        perform_create

        expect(response).to redirect_to courses_path
      end

      it 'sets a flash message' do
        perform_create

        expect(flash[:danger]).to eq(I18n.t('notice.enroll.failure'))
      end
    end
  end

  describe 'delete #unenroll' do
    context 'with valid attributes' do
      let!(:enrollment) do
        FactoryBot.create(:enrollment, user_id: user.id, course_id: course_1.id)
      end
      let(:valid_params) do
        {
          id: course_1.id,
          user_id: user.id,
        }
      end
      let(:perform_delete) { delete :unenroll, params: valid_params }

      it 'deletes the enrollment from database' do
        expect { perform_delete }.to change(Enrollment, :count).by(-1)
      end

      it 'sets a flash message' do
        perform_delete

        expect(flash[:success]).to eq(I18n.t('notice.unenroll.success'))
      end

      it 'redirects to courses path' do
        perform_delete

        expect(response).to redirect_to courses_path
      end
    end

    context 'with invalid attributes' do
      let(:invalid_params) do
        {
          user_id: user.id,
          id: invalid_id,
        }
      end
      let(:perform_delete) { delete :unenroll, params: invalid_params }

      it 'does not change courses database' do
        expect { perform_delete }.to change(Enrollment, :count).by(0)
      end

      it 'sets a flash message' do
        perform_delete

        expect(flash[:danger]).to eq(I18n.t('notice.record_not_found',
                                            resource: humanize(Course),
                                            id: invalid_id))
      end

      it 'redirects to courses path' do
        perform_delete

        expect(response).to redirect_to courses_path
      end
    end

    context 'with invalid user' do
      let(:invalid_params) do
        {
          user_id: invalid_id,
          id: course_1.id,
        }
      end
      let(:perform_delete) { delete :unenroll, params: invalid_params }

      it 'does not change courses database' do
        expect { perform_delete }.to change(Enrollment, :count).by(0)
      end

      it 'sets a flash message' do
        perform_delete

        expect(flash[:danger]).to eq(I18n.t('notice.record_not_found',
                                            resource: humanize(User),
                                            id: invalid_id))
      end

      it 'redirects to courses path' do
        perform_delete

        expect(response).to redirect_to courses_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      let(:course) { FactoryBot.attributes_for(:course, title: 'New Title') }
      let(:valid_params) do
        {
          id: course_1.id,
          user_id: user.id,
          course: course,
        }
      end
      before do
        patch :update, params: valid_params
      end

      it 'updates the course attributes in the Database' do
        expect(course_1.reload.title).to eq('New Title')
      end

      it 'sets a flash message' do
        expect(flash[:success]).to eq(I18n.t('notice.update.success',
                                             resource: humanize(Course)))
      end

      it 'redirects to course path' do
        expect(response).to redirect_to course_1
      end
    end

    context 'with invalid attributes' do
      let(:course) { FactoryBot.attributes_for(:course, content: nil) }
      let(:invalid_params) do
        {
          user_id: user.id,
          course: course,
          id: course_1.id,
        }
      end

      before do
        patch :update, params: invalid_params
      end

      it 'does not update the course attributes in the Database' do
        expect(course_1.reload.content).not_to be_nil
      end

      it 'sets a flash message' do
        expect(flash[:danger]).to eq(I18n.t('notice.update.failure',
                                            resource: humanize(Course)))
      end

      it 'renders template :edit' do
        expect(response).to render_template :edit
      end

      it 'has :bad_request http status' do
        expect(response).to have_http_status :bad_request
      end
    end

    context 'with unauthorized user' do
      let(:unauthorized_user) { FactoryBot.create(:user) }
      let(:course) { FactoryBot.attributes_for(:course, title: 'New Title') }
      let(:invalid_params) do
        {
          user_id: unauthorized_user.id,
          course: course,
          id: course_1.id,
        }
      end

      before do
        patch :update, params:  invalid_params
      end

      it 'does not update the course attributes in the Database' do
        expect(course_1.reload.title).not_to eq('New Title')
      end

      it 'sets a flash message' do
        expect(flash[:danger]).to eq(I18n.t('notice.record_not_found',
                                            resource: humanize(Course),
                                            id: course_1.id))
      end

      it 'renders template :edit' do
        expect(response).to redirect_to courses_path
      end
    end
  end

  describe 'course #destroy' do
    context 'with valid attributes' do
      let(:valid_params) do
        {
          user_id: user.id,
          id: course_1.id,
        }
      end
      let(:perform_delete) { delete :destroy, params: valid_params }

      before do
        course_1
      end

      it 'deletes the course from database' do
        expect { perform_delete }.to change(Course, :count).by(-1)
      end

      it 'sets a flash message' do
        perform_delete

        expect(flash[:success]).to eq(I18n.t('notice.delete.success',
                                             resource: humanize(Course)))
      end

      it 'redirects to courses path' do
        perform_delete

        expect(response).to redirect_to courses_path
      end
    end

    context 'with invalid attributes' do
      let(:invalid_params) do
        {
          user_id: user.id,
          id: invalid_id,
        }
      end
      let(:perform_delete) { delete :destroy, params: invalid_params }

      it 'does not change courses database' do
        expect { perform_delete }.to change(Course, :count).by(0)
      end

      it 'sets a flash message' do
        perform_delete

        expect(flash[:danger]).to eq(I18n.t('notice.record_not_found',
                                            resource: humanize(Course),
                                            id: invalid_id))
      end

      it 'redirects to courses path' do
        perform_delete

        expect(response).to redirect_to courses_path
      end
    end

    context 'with unauthorized user' do
      let(:unauthorized_user) { FactoryBot.create(:user) }
      let(:invalid_params) do
        {
          user_id: unauthorized_user.id,
          id: course_1.id,
        }
      end
      let(:perform_delete) { delete :destroy, params: invalid_params }

      before do
        course_1
      end

      it 'does not change courses database' do
        expect { perform_delete }.to change(Course, :count).by(0)
      end

      it 'sets a flash message' do
        perform_delete

        expect(flash[:danger]).to eq(I18n.t('notice.record_not_found',
                                            resource: humanize(Course),
                                            id: course_1.id))
      end

      it 'redirects to courses path' do
        perform_delete

        expect(response).to redirect_to courses_path
      end
    end
  end
end
