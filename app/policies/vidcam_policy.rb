class VidcamPolicy
  include VidcamsHelper

  attr_reader :user, :vidcam

  class Scope < Struct.new(:user, :scope)

    def resolve
      raise Pundit::NotAuthorizedError unless user
      if (user.director? || user.labasst?)
        scope.all
      else
        # Only allow the user to see vidcams in their courses
        scope.where(course_id: user.courses.map {|c| c.id})
      end
    end
  end

  def initialize(user, vidcam)
    raise Pundit::NotAuthorizedError unless user
    @user = user
    @vidcam = vidcam
  end

  def create_attributes
    [:course_id, :location, :start, :end, :publish_by, :upload_to_ensemble, :additional_instructions, publish_methods: []]
  end

  def update_attributes
    [:course_id, :location, :start, :end, :publish_by, :upload_to_ensemble, :additional_instructions, publish_methods: []]
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
    @user.director? || @user.labasst? || owns_vidcam
  end

  def edit?
    @user.director? || @user.labasst? || owns_vidcam
  end

  def update?
    @user.director? || @user.labasst? || owns_vidcam
  end

  def destroy?
    @user.director? || @user.labasst? || owns_vidcam
  end

  private

  # A user owns the vidcam if they a faculty member enrolled in the course attached to the vidcam.
  # This means that if there are 2+ users with role 'faculty' in a course that has a vidcam, they
  # will ALL have the same permissions on the vidcam
  def owns_vidcam
    puts "Owns vidcam?: #{@vidcam.course.users.include? @user}"
    @user.faculty? && (@vidcam.course.users.include? @user)
  end
end
