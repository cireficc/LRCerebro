class UserPolicy
    
    attr_reader :user, :user_resource

    def initialize(user, user_resource)
        raise Pundit::NotAuthorizedError unless user
        @user = user
        @user_resource = user_resource
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