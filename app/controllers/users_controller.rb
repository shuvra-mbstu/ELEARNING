class UsersController < ApplicationController
  before_action :set_user, except: %i(index new create)
  before_action :require_owner, only: %i(edit update destroy)
  skip_before_action :require_login, only: %i(index new create)

  def index
    @users = User.order(full_name: :asc)
  end

  def show
    @taught_courses = @user.taught_courses.order(title: :asc).page(params[:page]).per(5)
  end

  def new
    @user = User.new
  end

  def edit; end

  def create
    response = UserManager::RegisterUser.call(params: user_params)

    if response.success?
      redirect_to login_path, flash: { success: response.message }
    else
      @user = response.user
      flash.now[:danger] = response.message
      render :new, status: :bad_request
    end
  end

  def update
    if @user.update(user_params)
      flash[:success] = I18n.t('notice.update.success',
                               resource: I18n.t('views.shared.profile'))
      redirect_to @user
    else
      flash.now[:danger] = I18n.t('notice.update.failure',
                                  resource: I18n.t('views.shared.profile'))
      render :edit, status: :bad_request
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = I18n.t('notice.delete.success',
                               resource: I18n.t('views.shared.profile'))
    else
      flash[:danger] = I18n.t('notice.delete.failure',
                              resource: I18n.t('views.shared.profile'))
    end
    redirect_to root_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = I18n.t('notice.record_not_found',
                            resource: humanize(User),
                            id: params[:id])
    redirect_to root_path
  end

  def require_owner
    return if owner?(@user.id)

    flash[:danger] = I18n.t('notice.user_not_authorized')
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit(:username, :full_name, :email, :location, :password)
  end
end
