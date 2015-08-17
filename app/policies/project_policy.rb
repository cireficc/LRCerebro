class ProjectPolicy
    include ProjectsHelper
    
    attr_reader :user, :project

    def initialize(user, project)
        @user = user
        @project = project
    end
  
    def index?
        @user.director? || @user.labasst?
    end
    
    def new?
        @user.director? || @user.labasst? || @user.faculty?
    end
    
    def create?
        @user.director? || @user.labasst? || @user.faculty?
    end
    
    def show?
        @user.director? || @user.labasst? || owns_project
    end
    
    def edit?
        @user.director?
    end
    
    def update?
        @user.director?
    end
    
    def destroy?
        @user.director?
    end
    
    private
    
    # A user owns the project if they a faculty member enrolled in the course attached to the project.
    # This means that if there are 2+ users with role 'faculty' in a course that has a project, they
    # will ALL have the same permissions on the project
    def owns_project
        @user.faculty? && (@project.course.users.include? @user)
    end
end