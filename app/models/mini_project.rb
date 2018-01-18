class MiniProject < ActiveRecord::Base

  attr_accessor :present

  searchkick

  belongs_to :course
  validates :course_id, :resources, :description, :start_date, :due_date, presence: true
  validates :supplemental_materials, inclusion: [true, false]
  validates_presence_of :supplemental_materials_description, if: :supplemental_materials?
  before_validation :reject_empty_resources

  after_create :create_or_update_publishing_event, :unless => :seeding_development_database
  after_update :create_or_update_publishing_event
  before_destroy :delete_publish_calendar_event

  RESOURCES = [
      "Plex Music",
      "Films",
      "Delicast streaming TV",
      "DiLL",
      "Puppet Show",
      "Photobooth",
      "GarageBand",
      "Camtasia",
      "Video Camera",
      "Project Server",
      "Google Drive/Docs"
  ]

  def search_data
    {
        course: course.id,
        start_date: start_date,
        submitted_by: course.instructor.id,
        members: course.users.collect(&:id),
        year: course.year,
        semester: course.semester
    }
  end

  def reject_empty_resources
    resources.reject! { |l| l.empty? }
  end

  def active?
    self.course.active?
  end

  def create_or_update_publishing_event
    return if self.publish_by.nil?
    method = self.google_calendar_publish_event_id.blank? ? :create : :update
    GoogleCalendarHelper.schedule_project_publish_event(self, method)
  end

  def delete_publish_calendar_event
    GoogleCalendarHelper.delete_project_publish_event(self)
  end

  def seeding_development_database
    Rails.env.development? && ApplicationController::SEEDING_IN_PROGRESS == true
  end
end
