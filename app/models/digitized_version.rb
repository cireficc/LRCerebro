class DigitizedVersion < ActiveRecord::Base
    
    belongs_to :film
    
    validates :audio_language, presence: true
    
    def generated_filename
        return "" if film.nil?

        filename = film.inventory_item.catalog_number
        filename += " #{film.foreign_title}"
        filename += " (#{film.english_title})" if film.english_title.present?
        filename += " [#{full_title}]" if full_title

        filename += " (Audio; #{audio_language}"
        if (subtitle_language.present?)
            filename +=  ", Subtitles; #{subtitle_language})"
        else
            filename += ")";
        end
    end
  
    def full_title
      if foreign_title.present? && english_title.present?
        "#{foreign_title} - #{english_title}"
      elsif foreign_title.present?
        foreign_title
      elsif english_title.present?
        english_title
      end
      
      return nil
    end
end
