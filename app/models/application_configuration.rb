class ApplicationConfiguration < ActiveRecord::Base
    
    validates   :enrollment_update_message, :enrollment_last_updated,
                :current_semester_start, :current_semester_end, :current_semester_year, :current_semester,
                :class_project_submission_start, :class_project_submission_end,
                :class_project_before_deadline_message, :class_project_after_deadline_message,
                presence: true
                
    validate :semester_dates_valid
    validate :project_deadline_dates_valid
    
    enum current_semester: Course.semesters
    
    def semester_dates_valid
        if self.current_semester_start > self.current_semester_end
            self.errors.add(:current_semester_start, "semester start time must be earlier than end time")
            self.errors.add(:current_semester_end, "semester start time must be earlier than end time") 
        end
    end
    
    def project_deadline_dates_valid
        if self.class_project_submission_start > self.class_project_submission_end
            self.errors.add(:class_project_submission_start, "project submission start time must be earlier than end time")
            self.errors.add(:class_project_submission_end, "project submission start time must be earlier than end time") 
        end
    end
end
