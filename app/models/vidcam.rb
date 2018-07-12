class Vidcam < ActiveRecord::Base

  attr_accessor :present

  searchkick

  belongs_to :course
  validates :course_id, :location, :start, :end, :publish_by, presence: true
  validates :upload_to_ensemble, inclusion: [true, false]
  validate :start_time_before_end_time, if: lambda { |a| a.start? && a.end? }

  after_create :create_or_update_filming_event, :create_or_update_publishing_event, :create_vidcam_task, unless: :seeding_development_database
  after_update :create_or_update_publishing_event
  before_destroy :delete_filming_event, :delete_publishing_event

  def search_data
    {
        course: course.id,
        start: start,
        submitted_by: course.instructor.id,
        members: course.users.collect(&:id),
        year: course.year,
        semester: course.semester
    }
  end

  def start_time_before_end_time
    if self.start > self.end
      self.errors.add(:start, "event start time must be earlier than end time")
      self.errors.add(:end, "event start time must be earlier than end time")
    end
  end

  def active?
    self.course.active?
  end

  def create_or_update_filming_event
    if self.google_calendar_filming_event_id.blank?
      GoogleCalendarHelper.delay.create_vidcam_filming_event(self.id)
    else
      GoogleCalendarHelper.delay.update_vidcam_filming_event(self.id)
    end
  end

  def create_or_update_publishing_event
    if self.google_calendar_publishing_event_id.blank?
      GoogleCalendarHelper.delay.create_vidcam_publishing_event(self.id)
    else
      GoogleCalendarHelper.delay.update_vidcam_publishing_event(self.id)
    end
  end

  def delete_filming_event
    GoogleCalendarHelper.delay.delete_vidcam_filming_event(self.google_calendar_filming_event_id)
  end

  def delete_publishing_event
    GoogleCalendarHelper.delay.delete_vidcam_publishing_event(self.google_calendar_publishing_event_id)
  end

  def create_vidcam_task
    AsanaHelper.create_vidcam_task(self.id)
  end

  def seeding_development_database
    Rails.env.development? && ApplicationController::SEEDING_IN_PROGRESS == true
  end

  handle_asynchronously :create_vidcam_task
end
