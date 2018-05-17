class ApplicationController < ActionController::Base
  # Resource authorization gem
  include Pundit
  include ApplicationHelper
  include GoogleCalendarHelper
  include UsersHelper
  include ActionController::Serialization
  # Hack-load LdapAuthenticatable so that it's defined and can be used by other controller actions
  Devise::Strategies::LdapAuthenticatable

  # Pseudo-global used to detect whether or not the app is currently being seeded
  SEEDING_IN_PROGRESS = false

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_view_path
  before_action :set_i18n_path, only: [:create, :update, :destroy]
  after_action :store_last_page

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  # Set the view directory path based on the controller and the user's role.
  # This allows us to divide the view folders more explicitly and prevent forms
  # from being cluttered with user.role calls to render particular form components.
  def set_view_path
    if current_user
      @view_path = "#{controller_name}/#{current_user.role}"
    else
      @view_path = "#{controller_name}"
    end
  end

  # Set the i18n common translation path based on the controller and action.
  def set_i18n_path
    @i18n_path = "#{controller_name.singularize}.#{action_name}"
    puts "i18n path: #{@i18n_path}"
  end

  def store_last_page
    session[:last_page] = request.referrer
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
