class ApplicationController < ActionController::Base
  # Resource authorization gem
  include Pundit
  include ApplicationHelper
  include AccountHelper
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  after_action :store_last_page
  
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private
  
  def store_last_page
    session[:last_page] = request.url
  end
  
  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    # Load each part of the "No permission" message
    intro = t :not_authorized_intro, scope: "pundit" # You do not have permission to...
    rest = t "#{policy_name}.#{exception.query}", scope: "pundit" # ... create/view/edit/update/delete _resource_

    # If the user is logged in, present a specific authorization message, otherwise present the default "must log in" message
    flash.now[:danger] = (current_user) ? "#{intro} #{rest}" : (t :default, scope: "pundit")
    
    render 'static_pages/403'
  end
end
