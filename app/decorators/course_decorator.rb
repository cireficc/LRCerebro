class CourseDecorator < Draper::Decorator
  delegate_all
  delegate :course

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def short_name
    department_code = Course::DEPARTMENT_CODES.key(Course.departments[department])
    sektion = "%02d" % section

    "#{department_code}-#{course}-#{sektion}"
  end

  def full_name
    "#{name} (#{semester.titleize} #{year})"
  end

end
