require 'rails_helper'

RSpec.describe CategoriesController do
  let(:category) { FactoryBot.create(:category) }

  describe 'GET #index' do
    before do
      category
      get :index
    end

    it 'populates an array of categories' do
      expect(assigns(:categories)).to eq([category])
    end

    it 'renders :index template' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    context 'with valid attributes' do
      let!(:course) { FactoryBot.create(:course, category: category) }

      before do
        get :show, params: { id: category.id }
      end

      it 'assigns requested category to @category' do
        expect(assigns(:category)).to eq(category)
      end

      it 'populates associated courses to @courses' do
        expect(assigns(:courses)).to eq([course])
      end

      it 'renders :show template' do
        expect(response).to render_template :show
      end
    end

    context 'with invalid attributes' do
      before { get :show, params: { id: -1 } }

      it 'redirects to categories path' do
        expect(response).to redirect_to categories_path
      end

      it 'sets a flash message' do
        expect(flash[:danger]).to eq('Category not found!')
      end
    end
  end

  describe 'when logged in as admin' do
    let(:admin) { FactoryBot.create(:user, admin: true) }
    let(:course_1) { FactoryBot.create(:course, category: nil) }
    let(:course_2) { FactoryBot.create(:course, category: nil) }

    before { login_as admin }

    describe 'GET #new' do
      before { get :new, xhr: true }

      it 'assigns @category as a new record' do
        expect(assigns(:category)).to be_a_new(Category)
      end
    end

    describe 'GET #edit' do
      before { get :edit, params: { id: category.id } }

      it 'assigns requested category to @category' do
        expect(assigns(:category)).to eq(category)
      end

      it 'renders :edit template' do
        expect(response).to render_template :edit
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        let(:valid_category_params) { FactoryBot.attributes_for(:category) }
        let(:perform_post) { post :create, xhr: true, params: { category: valid_category_params } }

        it 'saves a new category in the Database' do
          expect { perform_post }.to change(Category, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        let(:invalid_category_params) { { name: 'Taken' } }
        let(:perform_post) { post :create, xhr: true, params: { category: invalid_category_params } }

        before { FactoryBot.create(:category, name: 'Taken') }

        it 'does not save the category in the Database' do
          expect { perform_post }.to change(Category, :count).by(0)
        end
      end
    end

    describe 'PATCH #update' do
      context 'with valid attributes' do
        let(:valid_update_params) { { name: 'New Category' } }

        before do
          patch :update, params: { category: valid_update_params, id: category.id }
          category.reload
        end

        it 'updates the category attributes' do
          expect(category.name).to eq('New Category')
        end

        it 'redirects to categories path' do
          expect(response).to redirect_to categories_path
        end
      end

      context 'with invalid attributes' do
        let(:invalid_update_params) { { name: nil } }

        before do
          patch :update, params: { category: invalid_update_params, id: category.id }
          category.reload
        end

        it 'does not update the category attributes' do
          expect(category.name).to_not be_nil
        end

        it 'renders :edit template' do
          expect(response).to render_template :edit
        end

        it 'has :bad_request http status' do
          expect(response).to have_http_status :bad_request
        end
      end
    end

    describe 'DELETE #destroy' do
      context 'with valid attributes' do
        let(:perform_delete) { delete :destroy, xhr: true, params: { id: category.id } }

        before { category }

        it 'deletes the category from database' do
          expect { perform_delete }.to change(Category, :count).by(-1)
        end

        it 'sets a flash message' do
          perform_delete

          expect(flash[:success]).to eq(I18n.t('notice.delete.success', resource: humanize(Category)))
        end
      end

      context 'with invalid attributes' do
        let(:perform_delete) { delete :destroy, xhr: true, params: { id: -1 } }

        before { category }

        it 'does not change Category database' do
          expect { perform_delete }.to change(Category, :count).by(0)
        end
      end
    end

    describe 'GET #add_courses' do
      context 'with valid attributes' do
        before do
          get :add_courses, params: { id: category.id }
        end

        it 'assigns an array of courses to @courses' do
          expect(assigns(:courses)).to eq([course_1, course_2])
        end

        it 'renders :add_courses template' do
          expect(response).to render_template :add_courses
        end
      end

      context 'with invalid attributes' do
        before do
          get :add_courses, params: { id: -1 }
        end

        it 'sets a flash message' do
          expect(flash[:danger]).to eq('Category not found!')
        end

        it 'redirects to categories path' do
          expect(response).to redirect_to categories_path
        end
      end
    end

    describe 'Patch #update_courses' do
      let(:ids) { [course_1.id, course_2.id] }

      context 'with valid attributes' do
        before do
          patch :update_courses, params: { course_ids: ids, id: category.id }
        end

        it 'updates courses category with the category' do
          course_1.reload
          course_2.reload

          expect(course_1.category).to eq(category)
          expect(course_2.category).to eq(category)
        end

        it 'sets a flash message' do
          expect(flash[:success]).to eq('Courses successfully updated with category!')
        end

        it 'redirects to category path' do
          expect(response).to redirect_to category_path(category)
        end
      end

      context 'when a faster thread deletes some selected courses' do
        before do
          course_2.destroy
          patch :update_courses, params: { course_ids: ids, id: category.id }
        end

        it 'updates available courses with category' do
          expect(course_1.reload.category).to eq(category)
        end

        it 'sets a flash message' do
          expect(flash[:danger]).to eq('1/2 course successfully updated.')
        end

        it 'redirects to category path' do
          expect(response).to redirect_to category_path(category)
        end
      end

      context 'when no course is selected' do
        before do
          patch :update_courses, params: { course_ids: [], id: category.id }
        end

        it 'sets a flash message' do
          expect(flash[:danger]).to eq('No course was selected to update.')
        end

        it 'redirect to categories path' do
          expect(response).to redirect_to categories_path
        end
      end

      context 'with invalid attributes' do
        before do
          patch :update_courses, params: { course_ids: [course_1.id], id: -1 }
        end

        it 'does not update courses category' do
          expect(course_1.reload.category).to be_nil
        end

        it 'sets a flash message' do
          expect(flash[:danger]).to eq('Category not found!')
        end

        it 'redirects to categories path' do
          expect(response).to redirect_to categories_path
        end
      end
    end
  end

  describe 'when logged in as user' do
    let(:user) { FactoryBot.create(:user) }

    before { login_as user }

    describe 'shared examples' do
      describe 'GET #new' do
        before { get :new }

        include_examples 'Category Access Denied Examples'
      end

      describe 'GET #edit' do
        before { get :edit, params: { id: category.id } }

        include_examples 'Category Access Denied Examples'
      end

      describe 'DELETE #destroy' do
        before { delete :destroy, params: { id: category.id } }

        include_examples 'Category Access Denied Examples'
      end
    end

    describe 'GET #add_courses' do
      before do
        get :add_courses, params: { id: category.id }
      end

      it 'sets a flash message' do
        expect(flash[:danger]).to eq('Access denied!')
      end

      it 'redirect to root path' do
        expect(response).to redirect_to root_path
      end
    end

    describe 'PATCH #update_courses' do
      before do
        patch :update_courses, params: { course_ids: [1, 2, 3], id: category.id }
      end

      it 'sets a flash message' do
        expect(flash[:danger]).to eq('Access denied!')
      end

      it 'redirect to root path' do
        expect(response).to redirect_to root_path
      end
    end
  end
end
