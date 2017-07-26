class FilmDigitizationPolicy
  include FilmDigitizationsHelper

  attr_reader :user, :film_digitization

  class Scope < Struct.new(:user, :scope)

    def resolve
      raise Pundit::NotAuthorizedError unless user
      if (user.director? || user.labasst?)
        scope.all
      else
        # Only allow the user to see digitizations in their courses
        scope.where(course_id: user.courses.map {|c| c.id})
      end
    end
  end

  def initialize(user, film_digitization)
    raise Pundit::NotAuthorizedError unless user
    @user = user
    @film_digitization = film_digitization
  end

  def create_attributes
    [:course_id, :film_id, :due_date, :media_source, :film_title, :audio_language, :subtitle_language, :additional_instructions]
  end

  def update_attributes
    [:course_id, :film_id, :due_date, :media_source, :film_title, :audio_language, :subtitle_language, :additional_instructions]
  end

  def new?
    @user.director? || @user.labasst? || @user.faculty?
  end

  def create?
    @user.director? || @user.labasst? || @user.faculty?
  end

  def show?
    @user.director? || @user.labasst? || owns_film_digitization
  end

  def edit?
    @user.director? || @user.labasst? || owns_film_digitization
  end

  def update?
    @user.director? || @user.labasst? || owns_film_digitization
  end

  def destroy?
    @user.director? || @user.labasst? || owns_film_digitization
  end

  private

  # A user owns the object if they a faculty member enrolled in the course attached to the object.
  # This means that if there are 2+ users with role 'faculty' in a course that has an activity, they
  # will ALL have the same permissions on the object
  def owns_film_digitization
    puts "Owns film digitization?: #{@film_digitization.course.users.include? @user}"
    @user.faculty? && (@film_digitization.course.users.include? @user)
  end
end
