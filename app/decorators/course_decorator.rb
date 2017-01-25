class CourseDecorator < Draper::Decorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def full_name
    "#{name} (#{semester.titleize} #{year})"
  end
  
end
