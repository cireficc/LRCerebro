class DigitizedVersion < ActiveRecord::Base
    
    belongs_to :film
    
    validates :audio_language, :direct_link, :embed_code, presence: true
    
    def generated_title
        return "" if film.nil?
        
        title = film.foreign_title;
        title += " (#{film.english_title})" if film.english_title.present?
        title += " (Audio: #{audio_language}"
        if (subtitle_language.present?)
            title +=  "; Subtitles: #{subtitle_language})"
        else
            title += ")";
        end
    end
end
