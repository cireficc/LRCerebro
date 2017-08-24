class StandardReservationPolicy
  include StandardReservationsHelper

  attr_reader :user, :standard_reservation

  class Scope < Struct.new(:user, :scope)

    def resolve
      raise Pundit::NotAuthorizedError unless user
      if (user.director? || user.labasst?)
        scope.all
      else
        # Only allow the user to see reservations in their courses
        scope.where(course_id: user.courses.map {|c| c.id})
      end
    end
  end

  def initialize(user, standard_reservation)
    raise Pundit::NotAuthorizedError unless user
    @user = user
    @standard_reservation = standard_reservation
  end

  def create_attributes
    [:course_id, :activity, :start, :end, :lab, :walkthrough, :additional_instructions, utilities: [], assistances: []]
  end

  def update_attributes
    [:course_id, :activity, :start, :end, :lab, :walkthrough, :additional_instructions, utilities: [], assistances: []]
  end

  def index?
    @user.director? || @user.labasst? || @user.faculty?
  end

  def new?
    @user.director? || @user.labasst? || @user.faculty?
  end

  def create?
    @user.director? || @user.labasst? || @user.faculty?
  end

  def show?
    @user.director? || @user.labasst? || owns_standard_reservation
  end

  def edit?
    @user.director? || @user.labasst? || owns_standard_reservation
  end

  def update?
    @user.director? || @user.labasst? || owns_standard_reservation
  end

  def destroy?
    @user.director? || @user.labasst? || owns_standard_reservation
  end

  private

  # A user owns the activity if they a faculty member enrolled in the course attached to the activity.
  # This means that if there are 2+ users with role 'faculty' in a course that has an activity, they
  # will ALL have the same permissions on the activity
  def owns_standard_reservation
    puts "Owns standard reservation?: #{@standard_reservation.course.users.include? @user}"
    @user.faculty? && (@standard_reservation.course.users.include? @user)
  end
end
