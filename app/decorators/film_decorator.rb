class FilmDecorator < Draper::Decorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def full_title_with_catalog_number
    if foreign_title.present? && english_title.present?
      return "(#{inventory_item.catalog_number}) #{foreign_title} - #{english_title}"
    elsif foreign_title.present?
      return "(#{inventory_item.catalog_number}) #{foreign_title}"
    elsif english_title.present?
      return "(#{inventory_item.catalog_number}) #{english_title}"
    end

    return nil
  end
  
  def stringified_audio_languages
    audio_languages.map { |l| l.titleize }.join(", ")
  end

  def stringified_subtitle_languages
    subtitle_languages.map { |l| l.titleize }.join(", ")
  end

  def stringified_directors
    directors.map { |d| d.name.titleize }.join(", ")
  end

  def stringified_cast_members
    cast_members.map { |c| c.name.titleize }.join(", ")
  end

  def stringified_genres
    genres.map { |g| g.name.titleize }.join(", ")
  end

  def short_description
    h.truncate(description, length: 150)
  end

end
