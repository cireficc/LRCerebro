class FilmDigitization < ActiveRecord::Base
  searchkick

  belongs_to :course
  belongs_to :film
  validates :course_id, :due_date, :media_source, :audio_language, :subtitle_language, presence: true
  validate :film_or_title_present
  
  after_create :create_film_digitization_task, unless: :seeding_development_database

  MEDIA_SOURCES = [
      "LRC film collection",
      "Drop off at LRC Help Desk"
  ]

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

  def film_or_title_present
    if film_id.blank? && film_title.blank?
      errors.add(:film_id, "Link to an existing film, or specify the film's title")
      errors.add(:film_title, "Link to an existing film, or specify the film's title")
    end
  end

  def active?
    self.course.active?
  end

  def create_film_digitization_task
    AsanaHelper.create_film_digitization_task(self.id)
  end

  def seeding_development_database
    Rails.env.development? && ApplicationController::SEEDING_IN_PROGRESS == true
  end

  handle_asynchronously :create_film_digitization_task
end
