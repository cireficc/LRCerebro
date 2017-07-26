class Enrollment < ActiveRecord::Base

  belongs_to :course
  belongs_to :user, foreign_key: :user_id, primary_key: :pitm

  # User roles in the MLL department and the LRC:
  # :instructor - Faculty in the MLL department who teach courses
  # :student - Students in the MLL department who enroll in courses
  enum role: {
      instructor: 0,
      student: 1
  }

  def active?
    self.updated_at > ApplicationConfiguration.last.current_semester_start
  end

  def archived?
    self.updated_at < ApplicationConfiguration.last.current_semester_start
  end
end