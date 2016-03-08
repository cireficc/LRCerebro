class StandardActivity < ActiveRecord::Base
    
    belongs_to :course
    validates :course_id, :activity, :walkthrough, :start, :end, :lab, presence: true
    
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
end