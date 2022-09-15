class ApplicationController < ActionController::Base
  before_action :require_login, :set_locale
  helper_method :current_user, :logged_in?, :owner?
  include ApplicationHelper

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      @current_user = user if user&.authenticated?(cookies[:remember_token])
    end
  end

  def owner?(user_id)
    return current_user.id == user_id if logged_in?
  end

  def logged_in?
    current_user.present?
  end

  def require_admin
    return if current_user.admin

    flash[:danger] = I18n.t('notice.access_denied')
    redirect_to root_path
  end

  def require_login
    return if logged_in?

    flash[:danger] = I18n.t('notice.require_login')
    render 'sessions/new', status: :unauthorized
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
