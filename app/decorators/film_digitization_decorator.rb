class FilmDigitizationDecorator < Draper::Decorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end
  
  def full_title
    film.present? ? film.decorate.full_title_with_catalog_number : film_title
  end

end
