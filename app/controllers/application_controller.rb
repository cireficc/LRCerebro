class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  # Resource authorization gem
  include Pundit
  include ApplicationHelper
  include AccountHelper
  
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private
  
  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    # Load each part of the "No permission" message
    intro = t :not_authorized_intro, scope: "pundit" # You do not have permission to...
    rest = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default # ... create/view/edit/update/delete _resource_

    flash[:danger] = "#{intro} #{rest}"
    redirect_to(request.referrer || root_path)
  end
end
