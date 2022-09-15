class CategoriesController < ApplicationController
  before_action :set_category, except: %i(index new create)
  before_action :require_admin, except: %i(index show)
  before_action :check_update_courses_params, only: :update_courses
  skip_before_action :require_login, only: %i(index show)

  def index
    @categories = Category.order(name: :asc)
  end

  def show
    @courses =  @category.courses.page(params[:page])
  end

  def new
    @category = Category.new
  end

  def edit; end

  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.js { flash.now[:success] = I18n.t('notice.create.success', resource: humanize(Category)) }
      else
        format.js { flash.now[:danger] = I18n.t('notice.create.failure', resource: humanize(Category)) }
      end
    end
  end

  def update
    if @category.update(category_params)
      flash[:success] = 'Category updated successfully!'
      redirect_to categories_path
    else
      error_reason = @category.errors.full_messages.join('. ')
      flash.now[:danger] = "Failed to update category details! Reason: #{error_reason}."
      render :edit, status: :bad_request
    end
  end

  def destroy
    respond_to do |format|
      if @category.destroy
        format.js { flash.now[:success] = I18n.t('notice.delete.success', resource: humanize(Category)) }
      else
        format.js { flash.now[:danger] = I18n.t('notice.delete.failure', resource: humanize(Category)) }
      end
    end
  end

  def add_courses
    @courses = Course.where(category_id: nil)
  end

  def update_courses
    update_courses_msg(update_courses_action, params[:course_ids].size)
    redirect_to @category
  rescue ActiveRecord::InvalidForeignKey
    flash[:danger] = 'Failed to update courses with category! Reason: Invalid Category Id.'
    redirect_to categories_path
  end

  private

  def set_category
    @category = Category.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Category not found!'
    redirect_to categories_path
  end

  def check_update_courses_params
    return if params[:course_ids]

    flash[:danger] = 'No course was selected to update.'
    redirect_to categories_path
  end

  def update_courses_msg(update_count, params_size)
    if params_size > update_count
      flash[:danger] = "#{update_count}/#{params_size} course successfully updated."
    else
      flash[:success] = 'Courses successfully updated with category!'
    end
  end

  def update_courses_action
    Course.where(id: params[:course_ids]).update_all(category_id: @category.id)
  end

  def category_params
    params[:category].permit(:name)
  end
end
