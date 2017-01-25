class UserDecorator < Draper::Decorator
  delegate_all
  decorates_association :courses

  def self.collection_decorator_class
    PaginatingDecorator
  end
  
  def full_name_reverse
    "#{last_name}, #{first_name}"
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def full_name_with_username
    "#{last_name}, #{first_name} (#{username})"
  end

end
