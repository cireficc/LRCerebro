class FilmPolicy
    
    attr_reader :user, :film

    def initialize(user, film)
        raise Pundit::NotAuthorizedError unless user
        @user = user
        @film = film
    end
    
    def new?
        @user.director? || @user.labasst?
    end
    
    def create?
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