class Enrollment < ActiveRecord::Base

    belongs_to :course
    belongs_to :user, foreign_key: :user_id, primary_key: :g_number
    
    def active?
        self.updated_at > ApplicationConfiguration.last.current_semester_start
    end
    
    def archived?
        self.updated_at < ApplicationConfiguration.last.current_semester_start
    end
end