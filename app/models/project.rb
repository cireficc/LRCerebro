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
    after_create :create_or_update_calendar_events, :unless => :seeding_development_database
    # ProjectReservations can be created in a Project update action, so check both cases
    after_update :create_or_update_calendar_events
    
    # Project categories
    # :camtasia - A video project using Camtasia Studio
    # :garage_band - A podcast-type project using Garage Band
    # :pixton - A comic book project using Pixton
    # :photo_booth - A short video or photo project using Photo Booth
    # :blog - A blog project using Google Sites
    # :pages - A document-based project using Pages
    # :other - A different type of project that should be detailed in the project's description
    enum category: {
        camtasia: 0,
        garage_band: 1,
        pixton: 2,
        photo_booth: 3,
        storybird: 7,
        blog: 4,
        pages: 5,
        other: 6
    }
    
    CATEGORY_TRAINING_EVENTS = {
        camtasia: 3,
        garage_band: 2,
        pixton: 2,
        photo_booth: 1,
        blog: 2,
        pages: 1,
        other: 2
    }
    
    CATEGORY_EDITING_EVENTS = {
        camtasia: 4,
        garage_band: 3,
        pixton: 3,
        photo_booth: 2,
        blog: 2,
        pages: 2,
        other: 3
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
            archived: !active?
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
    
    def create_calendar_events
        self.project_reservations.each do |res|
            res.create_calendar_event
        end
    end
    
    def create_or_update_calendar_events
        self.project_reservations.each do |res|
            # If the ProjectReservation GC id is blank, it means the event hasn't been created yet
            if res.google_calendar_event_id.blank?
                res.create_calendar_event
            else
                res.update_calendar_event
            end
        end
    end
    
    def seeding_development_database
       Rails.env.development? && ApplicationController::SEEDING_IN_PROGRESS == true
    end
end
