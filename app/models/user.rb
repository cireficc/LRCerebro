class User < ActiveRecord::Base
    
    has_many :enrollment, foreign_key: :user_id, primary_key: :g_number
    has_many :courses, :through => :enrollment
    
    # User roles in the MLL department and the LRC:
    # :director - Director and assistant director of the LRC. Highest privileges
    # :labasst - Lab assistants of the LRC. Elevated privileges
    # :faculty - Faculty in the MLL department who teach courses
    # :student - Students in the MLL department who enroll in courses
    enum role: [:director, :labasst, :faculty, :student]
    
    has_secure_password
    
    def active_courses
        self.courses.where(enrollments: {active: true})
    end
end
