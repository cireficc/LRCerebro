class FilmDecorator < Draper::Decorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def short_description
    h.truncate(description, length: 150)
  end

end
