class WelcomeController < ApplicationController
  skip_before_action :require_login, only: :index

  def index
    return if current_user.nil?

    @taught_count = @current_user.taught_courses.count
  end
end
