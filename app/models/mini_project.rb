class MiniProject < ActiveRecord::Base

  attr_accessor :present

  searchkick

  belongs_to :course
  validates :course_id, :resources, :description, :start_date, :due_date, presence: true
  validates :supplemental_materials, inclusion: [true, false]
  before_validation :reject_empty_resources
  
  RESOURCES = [
      "Plex Music",
      "Films",
      "Delicast streaming TV",
      "DiLL",
      "Photobooth",
      "GarageBand",
      "Camtasia",
      "Project Server",
      "Google Drive/Docs"
  ]

  def search_data
    {
        course: course.id,
        start_date: start_date,
        submitted_by: course.instructor.id,
        members: course.users.collect(&:id),
        archived: !active?
    }
  end

  def reject_empty_resources
    resources.reject! { |l| l.empty? }
  end

  def active?
    self.course.active?
  end
end
