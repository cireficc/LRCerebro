class Course < ActiveRecord::Base

  searchkick

  has_many :enrollment
  has_many :users, :through => :enrollment

  accepts_nested_attributes_for :enrollment,
                                :allow_destroy => true,
                                :reject_if     => :all_blank
  has_many :projects
  has_many :mini_projects
  has_many :standard_reservations
  has_many :film_digitizations
  has_many :vidcams
  has_many :works

  validates :name, :department, :course, :section, :year, :semester, presence: true
  validates_associated :enrollment

  after_commit :reindex_associations

  scope :active, -> {
    config = ApplicationConfiguration.last
    # Enums don't work in where clauses < Rails 5: https://github.com/rails/rails/issues/19964#issuecomment-98591859
    where(year: config.current_semester_year, semester: Course.semesters[config.current_semester])
  }
  scope :archived, -> {
    config = ApplicationConfiguration.last
    # Enums don't work in where clauses < Rails 5: https://github.com/rails/rails/issues/19964#issuecomment-98591859
    where("year != ? OR semester != ?", config.current_semester_year, Course.semesters[config.current_semester])

  }

  # Enum to describe the semester in which a course takes place.
  # Although there are technically 3 summer semester types
  # (6-week 1, 6-week 2, 12-week), classify them all as summer
  # because that's way easier, and it doesn't really make a difference.
  enum semester: {
      fall: 0,
      winter: 1,
      summer: 2
  }

  # The integer semester codes from Blackboard that correspond to the semester enum
  SEMESTER_CODES = {
      10 => semesters[:fall],
      20 => semesters[:winter],
      30 => semesters[:summer]
  }

  # Enum to describe the MLL department to which the course belongs.
  # Basically, each language has its own department.
  enum department: {
      arabic: 0,
      chinese: 1,
      french: 2,
      german: 3,
      italian: 4,
      japanese: 5,
      russian: 6,
      spanish: 7,
      lrc: 8,
      mll: 10,
      honors: 11,
      other: 9
  }

  # The 3-character language codes that correspond to the department for the course (most of the time)
  # Special cases include (but may not be limited to):
  #   - EAS: East Asian Studies
  #   - LAS: Latin American Studies
  #   - MES: Middle Eastern Studies
  #   - RST: Russian Studies
  # The special cases have their department as 'other', which is set during database seeding.
  DEPARTMENT_CODES = {
      "ARA" => departments[:arabic],
      "CHI" => departments[:chinese],
      "FRE" => departments[:french],
      "GER" => departments[:german],
      "ITA" => departments[:italian],
      "JPN" => departments[:japanese],
      "RUS" => departments[:russian],
      "SPA" => departments[:spanish],
      "LRC" => departments[:lrc],
      "MLL" => departments[:mll],
      "HNR" => departments[:honors],
      "OTH" => departments[:other]
  }

  def search_data
    {
        name: name,
        department: department,
        course: course,
        section: section,
        year: year,
        semester: semester
    }
  end

  def reindex_associations
    users.each { |u| u.reindex }
    projects.each { |p| p.reindex }
    mini_projects.each { |mp| mp.reindex }
    standard_reservations.each { |sr| sr.reindex }
    film_digitizations.each { |fd| fd.reindex }
    vidcams.each { |vc| vc.reindex }
    works.each { |w| w.reindex }
  end

  def active?
    config = ApplicationConfiguration.last
    self.year == config.current_semester_year && self.semester == config.current_semester
  end

  def archived?
    config = ApplicationConfiguration.last
    self.year != config.current_semester_year || self.semester != config.current_semester
  end

  def instructor
    User.includes(:enrollment).where(enrollments: {course_id: self, role: Enrollment.roles[:instructor]}).first || User.find_by_username('instructor_tbd')
  end

  def students
    User.includes(:enrollment).where(enrollments: {course_id: self, role: Enrollment.roles[:student]})
  end
end
