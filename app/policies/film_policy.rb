class FilmPolicy

  attr_reader :user, :film

  def initialize(user, film)
    @user = user
    @film = film
  end

  def new?
    @user && (@user.director? || @user.labasst?)
  end

  def create?
    @user && (@user.director? || @user.labasst?)
  end

  def edit?
    @user && (@user.director? || @user.labasst?)
  end

  def update?
    @user && (@user.director? || @user.labasst?)
  end

  def destroy?
    @user && (@user.director? || @user.labasst?)
  end
end
