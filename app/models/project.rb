class Project < ActiveRecord::Base
    
    searchkick
    
    belongs_to :course
    has_many :project_reservations, :dependent => :destroy
    accepts_nested_attributes_for :project_reservations, :reject_if => lambda { |a| a[:start].blank? && a[:end].blank? }, :allow_destroy => true
    validates :course_id, :category, :name, :description, :script_due, :due, presence: true
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
        {
            name: name,
            description: description,
            category: category,
            script_due: script_due,
            due: due,
            course: course.id,
            submitted_by: course.instructors.collect(&:id),
            first_training: project_reservations.order(:start).find_by(category: ProjectReservation.categories[:training]).start,
            last_editing: project_reservations.order(:start).reverse_order.find_by(category: ProjectReservation.categories[:editing]).start,
            created_at: created_at,
            approved: approved,
            members: course.users.collect(&:id),
            year: course.year,
            semester: course.semester
        }
    end
    
    def active?
        self.updated_at > ApplicationConfiguration.last.current_semester_start
    end
    
    def archived?
        self.updated_at < ApplicationConfiguration.last.current_semester_start
    end
    
    def first_training
        self.project_reservations.order(:start).find_by(category: ProjectReservation.categories[:training])
    end
    
    def last_editing
        self.project_reservations.order(:start).reverse_order.find_by(category: ProjectReservation.categories[:editing])
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
