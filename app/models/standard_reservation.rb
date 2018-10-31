class StandardReservation < ActiveRecord::Base
  
  attr_accessor :current_user
  attr_accessor :view_context

  searchkick

  belongs_to :course
  validates :course_id, :activity, :start, :end, :lab, presence: true
  validates :walkthrough, inclusion: [true, false]
  validate :start_time_before_end_time, if: lambda {|r| r.start? && r.end?}
  validate :not_same_day_reservation, if: lambda {|r| puts r.inspect; r.current_user.faculty? && r.start? && r.end?}

  after_create :create_or_update_calendar_event, :unless => :seeding_development_database
  after_update :create_or_update_calendar_event
  before_destroy :delete_calendar_event

  # Standard activity types
  # DiLL Paired (Synchronous) Recordings - DiLL recordings where students are paired together to record
  # DiLL Individual (Asynchronous) Recordings - DiLL recordings where students record individually
  # Writing or Web Research - Students write papers or do web research
  # Film Viewing - Film viewing
  # MLPA-CoLa Testing - MLPA-CoLa Test session
  # Skype Session - Skype session with a remote person
  # LRC Orientation - Freshman orientation or orientation for low-level MLL courses
  ACTIVITIES = [
      "DiLL Paired (Synchronous) Recordings",
      "DiLL Individual (Asynchronous) Recordings",
      "Photo Booth",
      "Writing or Web Research",
      "Film Viewing",
      "MLPA-CoLa Testing",
      "Skype Session",
      "LRC Orientation"
  ]

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
        submitted_by: course.instructor.id,
        activity: activity,
        reservation_start: start,
        lab: lab,
        members: course.users.collect(&:id),
        year: course.year,
        semester: course.semester
    }
  end
  
  def not_same_day_reservation
    
    if self.start >= now.beginning_of_day && self.end <= now.end_of_day
      now = DateTime.now
      ds_mailto = view_context.mail_to('shultzd@gvsu.edu', 'David Shultz', {subject: 'LRCerebro - Same-day Lab Reservation'})
      vc_mailto = view_context.mail_to('clappve@gvsu.edu', 'Veronica Clapp', {subject: 'LRCerebro - Same-day Lab Reservation'})
      error_message = view_context.t('error_same_day_reservation', scope: 'forms.standard_reservation', today: now.to_date, ds_mailto: ds_mailto, vc_mailto: vc_mailto).html_safe
      
      self.errors.add(:start, error_message)
      self.errors.add(:end, error_message)
    end
  end

  def start_time_before_end_time

    if self.start >= self.end
      error_message = 'reservation start time must be earlier than end time'
      
      self.errors.add(:start, error_message)
      self.errors.add(:end, error_message)
    end
  end

  def active?
    self.course.active?
  end

  def create_or_update_calendar_event
    if self.google_calendar_event_id.blank?
      GoogleCalendarHelper.delay.create_standard_reservation_event(self.id)
    else
      GoogleCalendarHelper.delay.update_standard_reservation_event(self.id)
    end
  end

  def delete_calendar_event
    # Use the google_calendar_event_id because the record is deleted before the DelayedJob can run
    GoogleCalendarHelper.delay.delete_standard_reservation_event(self.google_calendar_event_id)
  end

  def seeding_development_database
    Rails.env.development? && ApplicationController::SEEDING_IN_PROGRESS == true
  end
end
