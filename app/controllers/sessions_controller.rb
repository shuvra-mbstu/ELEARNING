class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i(new create)

  def new; end

  def create
    response = UserManager::AuthenticateUser.call(session_params)

    if response.success?
      log_in(response.user)
      redirect_to root_path, flash: { success: response.message }
    else
      flash.now[:danger] = response.message
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:info] = I18n.t('notice.sessions.logout')
    redirect_to root_url
  end

  private

  def log_in(user)
    reset_session
    params[:session][:remember_me] == '1' ? remember(user) : forget(user)
    session[:user_id] = user.id
  end

  def log_out
    forget(@current_user)
    reset_session
    @current_user = nil
  end

  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def session_params
    params.require(:session).permit(:email, :password, :remember_me)
  end
end
