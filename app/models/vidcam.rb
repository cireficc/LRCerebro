class Vidcam < ActiveRecord::Base

  attr_accessor :present

  searchkick

  belongs_to :course
  validates :course_id, :location, :start, :end, :publish_by, presence: true
  validates :upload_to_ensemble, inclusion: [true, false]
  validate :start_time_before_end_time, if: lambda { |a| a.start? && a.end? }

  after_create :create_or_update_filming_event, :create_or_update_publishing_event, :unless => :seeding_development_database
  after_update :create_or_update_publishing_event
  before_destroy :delete_filming_event, :delete_publishing_event

  def search_data
    {
        course: course.id,
        start: start,
        submitted_by: course.instructor.id,
        members: course.users.collect(&:id),
        archived: !active?
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
    method = self.google_calendar_filming_event_id.blank? ? :create : :update
    GoogleCalendarHelper.schedule_vidcam_filming_event(self, method)
  end

  def create_or_update_publishing_event
    method = self.google_calendar_publishing_event_id.blank? ? :create : :update
    GoogleCalendarHelper.schedule_vidcam_publishing_event(self, method)
  end

  def delete_filming_event
    GoogleCalendarHelper.delete_vidcam_filming_event(self)
  end

  def delete_publishing_event
    GoogleCalendarHelper.delete_vidcam_publish_event(self)
  end

  def seeding_development_database
    Rails.env.development? && ApplicationController::SEEDING_IN_PROGRESS == true
  end
end