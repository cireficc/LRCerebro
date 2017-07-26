class WorkPolicy
  include WorksHelper

  attr_reader :user, :work

  class Scope < Struct.new(:user, :scope)

    def resolve
      raise Pundit::NotAuthorizedError unless user
      if (user.director? || user.labasst?)
        scope.all
      else
        # Only allow the user to see works in their courses
        scope.where(course_id: user.courses.map {|c| c.id})
      end
    end
  end

  def initialize(user, work)
    raise Pundit::NotAuthorizedError unless user
    @user = user
    @work = work
  end

  def create_attributes
    [:course_id, :due_date, :instructions]
  end

  def update_attributes
    [:course_id, :due_date, :instructions]
  end

  def new?
    @user.director? || @user.labasst? || @user.faculty?
  end

  def create?
    @user.director? || @user.labasst? || @user.faculty?
  end

  def show?
    @user.director? || @user.labasst? || owns_work
  end

  def edit?
    @user.director? || @user.labasst? || owns_work
  end

  def update?
    @user.director? || @user.labasst? || owns_work
  end

  def destroy?
    @user.director? || @user.labasst? || owns_work
  end

  private

  # A user owns the work if they a faculty member enrolled in the course attached to the work.
  # This means that if there are 2+ users with role 'faculty' in a course that has a work, they
  # will ALL have the same permissions on the work
  def owns_work
    puts "Owns work?: #{@work.course.users.include? @user}"
    @user.faculty? && (@work.course.users.include? @user)
  end
end
