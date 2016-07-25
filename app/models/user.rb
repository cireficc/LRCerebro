class User < ActiveRecord::Base
    
    searchkick
    
    has_many :enrollment, foreign_key: :user_id, primary_key: :g_number
    has_many :courses, :through => :enrollment
    
    accepts_nested_attributes_for :courses
    
    validates :g_number, :username, :first_name, :last_name, :role, presence: true
    
    scope :active, -> { where("#{self.table_name}.updated_at > ?", ApplicationConfiguration.last.current_semester_start) }
    scope :archived, -> { where("#{self.table_name}.updated_at < ?", ApplicationConfiguration.last.current_semester_start) }
    
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
            g_number: g_number,
            first_name: first_name,
            last_name: last_name,
            role: role,
            active_courses: active_courses.collect(&:id)
        }
    end
    
    has_secure_password
    
    def active?
        self.updated_at > ApplicationConfiguration.last.current_semester_start
    end
    
    def archived?
        self.updated_at < ApplicationConfiguration.last.current_semester_start
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
    
    def full_name
       "#{last_name}, #{first_name}" 
    end
    
    def full_name_with_username
        "#{last_name}, #{first_name} (#{username})"
    end
end
