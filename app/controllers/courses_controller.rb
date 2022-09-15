class CoursesController < ApplicationController
  before_action :set_user, except: %i(index show search)
  before_action :find_course, only: %i(edit update destroy show)
  skip_before_action :require_login, only: :index

  def index
    if params[:search].present?
      @query = params[:search][:query]
      @page = params[:search][:page].to_i.abs
      @courses = Course.find_course(@query).paginate(@page)
      render :search
    else
      all_courses = if params[:category_id]
                      Course.where(category_id: params[:category_id])
                    else
                      Course.all
                    end
      @courses = all_courses.page(params[:page])
      respond_to { |format| format.js } if request.xhr?
      @categories = Category.all
    end
  end

  def show; end

  def new
    @course = Course.new
  end

  def edit; end

  def create
    @course = @user.taught_courses.new(course_params)

    if @course.save
      flash[:success] = I18n.t('notice.create.success', resource: humanize(Course))
      redirect_to courses_path
    else
      flash[:danger] = I18n.t('notice.create.failure', resource: humanize(Course))
      render :new, status: :bad_request
    end
  end

  def update
    if @course.update(course_params)
      flash[:success] = I18n.t('notice.update.success', resource: humanize(Course))
      redirect_to @course
    else
      flash[:danger] = I18n.t('notice.update.failure', resource: humanize(Course))
      render :edit, status: :bad_request
    end
  end

  def destroy
    if @course.destroy
      flash[:success] = I18n.t('notice.delete.success', resource: humanize(Course))
    else
      flash[:danger] = I18n.t('notice.delete.failure', resource: humanize(Course))
    end
    redirect_to courses_path
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = I18n.t('notice.record_not_found',
                            resource: humanize(User),
                            id: params[:user_id])
    redirect_to courses_path
  end

  def find_course
    @course = if @user.nil? || current_user.admin
                Course.find(params[:id])
              else
                @user.taught_courses.find(params[:id])
              end
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = I18n.t('notice.record_not_found',
                            resource: humanize(Course),
                            id: params[:id])
    redirect_to courses_path
  end

  def course_params
    params.require(:course).permit(:title, :category_id, :video_tutorial, :thumbnails)
  end
end
