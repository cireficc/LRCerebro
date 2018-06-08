class Work < ActiveRecord::Base
  searchkick

  belongs_to :course
  validates :course_id, :due_date, :instructions, presence: true
  after_create :create_work_task, unless: :seeding_development_database

  def search_data
    {
        course: course.id,
        due_date: due_date,
        submitted_by: course.instructor.id,
        members: course.users.collect(&:id),
        year: course.year,
        semester: course.semester
    }
  end

  def active?
    self.course.active?
  end
  
  def create_work_task
    AsanaHelper.create_work_task(self)
  end

  def seeding_development_database
    Rails.env.development? && ApplicationController::SEEDING_IN_PROGRESS == true
  end
end
