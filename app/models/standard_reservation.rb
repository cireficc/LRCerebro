class StandardReservation < ActiveRecord::Base
    
    searchkick
    
    belongs_to :course
    validates :course_id, :activity, :start, :end, :lab, presence: true
    validates :walkthrough, inclusion: [true, false]
    validate :start_time_before_end_time, if: lambda { |a| a.start? && a.end? }
    
    after_create :create_or_update_calendar_event, :unless => :seeding_development_database
    after_update :create_or_update_calendar_event
    before_destroy :delete_calendar_event
    
    # Standard activity types
    # :dill_paired_recordings - DiLL recordings where students are paired together to record
    # :dill_individual_recordings - DiLL recordings where students record individually
    # :writing_or_web_research - Students write papers or do web research
    # :film_viewing - Film viewing
    # :other - Other activities may include: MLPA-CoLa testing, Skype session, etc. 
    enum activity: {
        dill_paired_recordings: 0,
        dill_individual_recordings: 1,
        writing_or_web_research: 2,
        film_viewing: 3,
        other: 4
    }
    
    # Standard utility types
    # :roaming_support - Provide roaming support
    enum utility: {
        projector: 0,
        sound_system: 1
    }
    
    # Standard assistance types
    # :roaming_support - Provide roaming support
    # :simple_training - Provide simple how-to on software or processes
    # :application_set_up - Set up an application on student workstations
    # :launch_presentations_from_teacher_console - Launch presentations from the Teacher Console
    # :send_documents_to_student_workstations - Send documents to student workstations from the Teacher Console
    enum assistance: {
        roaming_support: 0,
        simple_training: 1,
        application_set_up: 2,
        launch_presentations_from_teacher_console: 3,
        send_documents_to_student_workstations: 4
    }
    
    # In order for form submissions to assign this property correctly, this enum has to be present
    # in this class. To follow DRY, we use the application-wide enum Lab.locations
    enum lab: Lab.locations
    
    def search_data
        {
            course: course.id,
            submitted_by: course.instructors.collect(&:id),
            activity: activity,
            reservation_start: start,
            lab: lab,
            members: course.users.collect(&:id),
            archived: !active?
        }
    end
    
    def start_time_before_end_time
        if self.start > self.end
            self.errors.add(:start, "reservation start time must be earlier than end time")
            self.errors.add(:end, "reservation start time must be earlier than end time")
        end
    end
    
    def active?
        self.course.active?
    end
    
    def create_or_update_calendar_event
        if self.google_calendar_event_id.blank?
            GoogleCalendarHelper.schedule_standard_reservation(self, :create)
        else
            GoogleCalendarHelper.schedule_standard_reservation(self, :update)
        end
    end
    
    def delete_calendar_event
        GoogleCalendarHelper.delete_standard_reservation(self)
    end
    
    def seeding_development_database
       Rails.env.development? && ApplicationController::SEEDING_IN_PROGRESS == true
    end
end