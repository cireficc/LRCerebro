class MiniProjectPolicy
  include MiniProjectsHelper

  attr_reader :user, :mini_project

  class Scope < Struct.new(:user, :scope)

    def resolve
      raise Pundit::NotAuthorizedError unless user
      if (user.director? || user.labasst?)
        scope.all
      else
        # Only allow the user to see mini projects in their courses
        scope.where(course_id: user.courses.map {|c| c.id})
      end
    end
  end

  def initialize(user, mini_project)
    raise Pundit::NotAuthorizedError unless user
    @user = user
    @mini_project = mini_project
  end

  def create_attributes
    [:course_id, :description, :supplemental_materials, :supplemental_materials_description, :start_date, :due_date,
     :present, :publish_by, publish_methods: [], resources: []]
  end

  def update_attributes
    [:course_id, :description, :supplemental_materials, :supplemental_materials_description, :start_date, :due_date,
     :present, :publish_by, publish_methods: [], resources: []]
  end

  def new?
    @user.director? || @user.labasst? || @user.faculty?
  end

  def create?
    @user.director? || @user.labasst? || @user.faculty?
  end

  def show?
    @user.director? || @user.labasst? || owns_mini_project
  end

  def edit?
    @user.director? || @user.labasst? || owns_mini_project
  end

  def update?
    @user.director? || @user.labasst? || owns_mini_project
  end

  def destroy?
    @user.director? || @user.labasst? || owns_mini_project
  end

  private

  # A user owns the mini project if they a faculty member enrolled in the course attached to the mini project.
  # This means that if there are 2+ users with role 'faculty' in a course that has a project, they
  # will ALL have the same permissions on the project
  def owns_mini_project
    puts "Owns mini project?: #{@mini_project.course.users.include? @user}"
    @user.faculty? && (@mini_project.course.users.include? @user)
  end
end
