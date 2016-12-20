class User < ActiveRecord::Base
    
    searchkick
    devise :database_authenticatable, authentication_keys: [:username]
    
    has_many :enrollment, foreign_key: :user_id, primary_key: :pitm
    has_many :courses, :through => :enrollment
    
    accepts_nested_attributes_for :courses
    
    validates :username, :first_name, :last_name, :role, presence: true

    before_save :set_pitm
    
    # User roles in the MLL department and the LRC:
    # :director - Director and assistant director of the LRC. Highest privileges
    # :labasst - Lab assistants of the LRC. Elevated privileges
    # :faculty - Faculty in the MLL department who teach courses
    # :student - Students in the MLL department who enroll in courses
    enum role: {
        director: 0,
        labasst: 1,
        faculty: 2,
        student: 3
    }
    
    def search_data
        {
            username: username,
            first_name: first_name,
            last_name: last_name,
            role: role,
            active_courses: active_courses.collect(&:id),
            archived: !active?
        }
    end

    def set_pitm
        self.pitm = self.username.upcase
        return true
    end
    
    def active?
        self.courses.active.any?
    end
    
    def archived?
        !active?
    end
    
    def active_courses
        # Director and labasst will see all non-archived courses
        if (self.director? || self.labasst?)
            Course.active
        # Faculty and student will see non-archived courses that they are enrolled in
        else
            self.courses.active
        end
    end
    
    def full_name_reverse
       "#{last_name}, #{first_name}" 
    end
    
    def full_name
        "#{first_name} #{last_name}" 
    end
    
    def full_name_with_username
        "#{last_name}, #{first_name} (#{username})"
    end
end
