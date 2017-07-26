class ProjectReservation < ActiveRecord::Base

  belongs_to :project
  validates :start, :end, presence: true
  validate :start_time_before_end_time
  scope :ordered_start, -> { order(:start) }

  # Delete Google Calendar events here because ProjectReservation is deleted before (parent) Project
  before_destroy :delete_calendar_event

  # Project reservation categories
  # :training - This is for training the students (project overview, teaching software, etc.)
  # :editing - This is for editing the projects
  enum category: {
      training: 0,
      editing: 1
  }

  # Project reservation categories
  # :project_introduction - Introduce the project to the students, create accounts, demonstration/how-to's, etc.
  # :camera_training - Train the students how to operate the cameras
  # :camtasia_traning - Train the students how to use Camtasia Studio
  # :in_class_shoot - Students film during their class meeting time
  # :screen_final_project - Students screen their final projects
  enum subtype: {
      project_introduction: 0,
      camera_training: 1,
      camtasia_training: 2,
      in_class_shoot: 3,
      screen_final_project: 4
  }

  # In order for form submissions to assign this property correctly, this enum has to be present
  # in this class. To follow DRY, we use the application-wide enum Lab.locations
  enum lab: Lab.locations

  def start_time_before_end_time
    if self.start > self.end
      self.errors.add(:start, "reservation start time must be earlier than end time")
      self.errors.add(:end, "reservation start time must be earlier than end time")
    end
  end

  def create_calendar_event
    GoogleCalendarHelper.schedule_project_event(self, :create)
  end

  def update_calendar_event
    GoogleCalendarHelper.schedule_project_event(self, :update)
  end

  def delete_calendar_event
    GoogleCalendarHelper.delete_project_event(self)
  end
end
