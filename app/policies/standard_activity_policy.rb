class StandardActivityPolicy
    include StandardActivitiesHelper
    
    attr_reader :user, :standard_activity
    
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

    def initialize(user, standard_activity)
        raise Pundit::NotAuthorizedError unless user
        @user = user
        @standard_activity = standard_activity
    end
    
    def create_attributes
        [:course_id, :activity, :start, :end, :lab, :walkthrough, :additional_instructions, utilities: [], assistances: []]
    end
    
    def update_attributes
        [:course_id, :activity, :start, :end, :lab, :walkthrough, :additional_instructions, utilities: [], assistances: []]
    end
    
    def new?
        @user.director? || @user.labasst? || @user.faculty?
    end
    
    def create?
        @user.director? || @user.labasst? || @user.faculty?
    end
    
    def show?
        @user.director? || @user.labasst? || owns_standard_activity
    end
    
    def edit?
        @user.director? || owns_standard_activity
    end
    
    def update?
        @user.director? || owns_standard_activity
    end
    
    def destroy?
        @user.director? || owns_standard_activity
    end
    
    private
    
    # A user owns the activity if they a faculty member enrolled in the course attached to the activity.
    # This means that if there are 2+ users with role 'faculty' in a course that has an activity, they
    # will ALL have the same permissions on the activity
    def owns_standard_activity
        puts "Owns standard activity?: #{@standard_activity.course.users.include? @user}"
        @user.faculty? && (@standard_activity.course.users.include? @user)
    end
end