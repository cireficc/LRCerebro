class Project < ActiveRecord::Base
    
    belongs_to :course
    has_many :project_reservations, :dependent => :destroy
    accepts_nested_attributes_for :project_reservations, :reject_if => lambda { |a| a[:start].blank? && a[:end].blank? }, :allow_destroy => true
    validates :course_id, :category, :name, :description, :script_due, :due, presence: true
    validates_associated :project_reservations
    attr_accessor :present
    
    # Create/update Google Calendar events here because (children) ProjectReservation are created before Project
    after_create :create_calendar_events, :unless => :seeding_development_database
    after_update :update_calendar_events
    
    # Project categories
    # :camtasia - A video project using Camtasia Studio
    # :garage_band - A podcast-type project using Garage Band
    # :pixton - A comic book project using Pixton
    # :photo_booth - A short video or photo project using Photo Booth
    # :blog - A blog project using Google Sites
    # :pages - A document-based project using Pages
    # :other - A different type of project that should be detailed in the project's description
    enum category: [:camtasia, :garage_band, :pixton, :photo_booth, :blog, :pages, :other]
    
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
    
    def create_calendar_events
        self.project_reservations.each do |res|
           res.create_calendar_event
        end
    end
    
    def update_calendar_events
        self.project_reservations.each do |res|
           res.update_calendar_event
        end
    end
    
    def seeding_development_database
       Rails.env.development? && ApplicationController::SEEDING_IN_PROGRESS == true
    end
end
