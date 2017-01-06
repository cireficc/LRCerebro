class DigitizedVersion < ActiveRecord::Base
    
    belongs_to :film
    
    validates :audio_language, presence: true
    
    def generated_filename
        return "" if film.nil?

        filename = film.inventory_item.catalog_number
        filename += " #{film.foreign_title}"
        filename += " (#{film.english_title})" if film.english_title.present?

        filename += ' ['

        if (foreign_title.present? && english_title.present?)
            filename += "#{foreign_title} - #{english_title}"
        elsif (foreign_title.present?)
            filename += foreign_title
        elsif (english_title.present?)
            filename += english_title
        end

        filename += ']'

        filename += " (Audio; #{audio_language}"
        if (subtitle_language.present?)
            filename +=  ", Subtitles; #{subtitle_language})"
        else
            filename += ")";
        end
    end
end
