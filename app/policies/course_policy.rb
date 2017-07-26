class CoursePolicy

  attr_reader :user, :course

  def initialize(user, course)
    raise Pundit::NotAuthorizedError unless user
    @user = user
    @course = course
  end

  def index?
    @user.director? || @user.labasst?
  end

  def new?
    @user.director? || @user.labasst?
  end

  def create?
    @user.director? || @user.labasst?
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

  def destroy?
    @user.director? || @user.labasst?
  end
end
