class ProjectReservation < ActiveRecord::Base
    
    belongs_to :project
    validates :start, :end, presence: true
    
    # Project reservation categories
    # :training - This is for training the students (project overview, teaching software, etc.)
    # :editing - This is for editing the projects
    enum category: [:training, :editing]
    
    # Project reservation categories
    # :project_introduction - Introduce the project to the students, create accounts, demonstration/how-to's, etc.
    # :camera_training - Train the students how to operate the cameras
    # :camtasia_traning - Train the students how to use Camtasia Studio
    enum subtype: [:project_introduction, :camera_training, :camtasia_traning]
    
    # In order for form submissions to assign this property correctly, this enum has to be present
    # in this class. To follow DRY, we use the application-wide enum Lab.locations
    enum lab: Lab.locations
end
