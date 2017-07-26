class FilmDigitization < ActiveRecord::Base
  searchkick

  belongs_to :course
  belongs_to :film
  validates :course_id, :due_date, :media_source, :audio_language, :subtitle_language, presence: true
  validate :film_or_title_present

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
        archived: !active?
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
end
