class ApplicationConfigurationPolicy
  include ApplicationConfigurationsHelper

  attr_reader :user, :configuration

  class Scope < Struct.new(:user, :scope)

    def resolve
      raise Pundit::NotAuthorizedError unless user
      if (user.director? || user.labasst?)
        scope.all
      end
    end
  end

  def initialize(user, configuration)
    raise Pundit::NotAuthorizedError unless user
    @user = user
    @configuration = configuration
  end

  def update_attributes
    if @user.director?
      [:enrollment_update_message, :enrollment_last_updated, :current_semester_start, :current_semester_end,
       :current_semester_year, :current_semester, :class_project_submission_start, :class_project_submission_end,
       :class_project_before_deadline_message, :class_project_after_deadline_message]
    else
      [:enrollment_update_message, :enrollment_last_updated, :current_semester_start, :current_semester_end,
       :current_semester_year, :current_semester]
    end
  end

  def show?
    @user.director? || @user.labasst?
  end

  def edit?
    @user.director? || @user.labasst?
  end

  def update?
    @user.director? || @user.labasst?
  end
end
