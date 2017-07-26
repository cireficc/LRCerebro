module UsersHelper

  # Logs in the given user
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns true if the user is logged in, false otherwise
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  # Extra helper functions for user role (for brevity!)
  # When the user isn't logged in, prevents redundant checks and nil exceptions on @current_user
  def is_director?
    logged_in? && current_user.director?
  end

  def is_labasst?
    logged_in? && current_user.labasst?
  end

  def is_faculty?
    logged_in? && current_user.faculty?
  end

  def is_student?
    logged_in? && current_user.student?
  end
end
