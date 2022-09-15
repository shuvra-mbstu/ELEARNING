module CourseHelper
  def authorized?(author_id)
    return unless logged_in?

    current_user.id == author_id || current_user.admin
  end

  def enrolled_courses?(course_id)
    return unless logged_in?

    return true if current_user.enrolled_courses.find_by(id: course_id)
  end

  def not_author(author_id)
    !owner?(author_id)
  end
end
