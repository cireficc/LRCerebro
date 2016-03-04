class User < ActiveRecord::Base
    
    has_many :enrollment, foreign_key: :user_id, primary_key: :g_number
    has_many :courses, :through => :enrollment
    
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
    
    has_secure_password
    
    def active_courses
        # Director and labasst will see all non-archived courses
        if (self.director? || self.labasst?)
            Course.where(archived: false)
        # Faculty and student will see non-archived courses that they are enrolled in
        else
            self.courses.where(enrollments: {archived: false})
        end
    end
end
