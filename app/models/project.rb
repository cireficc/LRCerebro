class Project < ActiveRecord::Base

  searchkick

  belongs_to :course
  has_many :project_reservations, :dependent => :destroy
  accepts_nested_attributes_for :project_reservations, :reject_if => lambda { |a| a[:start].blank? && a[:end].blank? }, :allow_destroy => true
  validates :course_id, :category, :name, :description, :script_due, :due, :group_size, presence: true
  validates :group_size, inclusion: 1..4
  validates_associated :project_reservations
  attr_accessor :present

  scope :approved, -> { where(approved: true) }
  scope :pending, -> { where(approved: false) }

  # Create/update Google Calendar events here because (children) ProjectReservation are created before Project
  after_create :create_or_update_reservation_calendar_events, :create_or_update_publishing_event, :unless => :seeding_development_database
  # ProjectReservations can be created in a Project update action, so check both cases
  after_update :create_or_update_reservation_calendar_events, :create_or_update_publishing_event
  before_destroy :delete_publish_calendar_event

  # Project categories 
  # Camtasia - A video project using Camtasia Studio 
  # Garage Band - A podcast-type project using Garage Band 
  # Pixton - A comic book project using Pixton 
  # Photo Booth - A short video or photo project using Photo Booth 
  # Storybird - A short story project with artwork using Storybird
  # Blog - A blog project using Google Sites 
  # Pages - A document-based project using Pages 
  CATEGORIES = [
      "Camtasia",
      "Garage Band",
      "Pixton",
      "Photo Booth",
      "Storybird",
      "Blog",
      "Pages"
  ]

  # Publishing options
  # :web_archive - Publish project to the LRC's web archive
  # :google_drive_link_sent_to_you - Send the faculty a Google Drive link to their class/project folder
  enum publish_method: {
      web_archive: 0,
      google_drive_link_sent_to_you: 1
  }

  def search_data

    first_training_start = first_training.start if first_training
    last_editing_start = last_editing.start if last_editing

    {
        name: name,
        description: description,
        category: category,
        script_due: script_due,
        due: due,
        course: course.id,
        submitted_by: course.instructor.id,
        first_training: first_training_start,
        last_editing: last_editing_start,
        created_at: created_at,
        approved: approved,
        members: course.users.collect(&:id),
        year: course.year,
        semester: course.semester
    }
  end

  def active?
    self.course.active?
  end

  def first_training
    self.project_reservations.order(:start).find_by(category: ProjectReservation.categories[:training])
  end

  def last_editing
    self.project_reservations.order(:start).reverse_order.find_by(category: ProjectReservation.categories[:editing])
  end

  def students_per_group
    (self.course.students.length.to_f/self.group_size.to_f).ceil
  end

  # Schedule project reservation events
  def create_or_update_reservation_calendar_events
    self.project_reservations.each do |res|
      # If the ProjectReservation GC id is blank, it means the event hasn't been created yet
      if res.google_calendar_event_id.blank?
        res.create_calendar_event
      else
        res.update_calendar_event
      end
    end
  end

  # Schedule project publish event
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
