class Film < ActiveRecord::Base
    has_one :inventory_item, as: :inventoriable, dependent: :destroy
    
    validates :film_type, :year, :length, :mpaa_rating, presence: true
    validate :validate_audio_languages
    
    # Film types
    # :vhs - A VHS tape
    # :dvd_from_vhs - A VHS converted to DVD
    # :dvd - A DVD
    # :blu_ray A Blu-ray disc
    enum film_type: {
        vhs: 0,
        dvd_from_vhs: 1,
        dvd: 2,
        blu_ray: 3
    }
    
    # MPAA ratings
    # :g - General Audiences. All ages admitted
    # :pg - Parental Guidance Suggested. Some material may not be suitable for children
    # :pg_13 - Parents Strongly Cautioned. Some material may be inappropriate for children under 13
    # :r Restricted. Under 17 requires accompanying parent or adult guardian
    # :nc_17 No one 17 and under admitted
    enum mpaa_rating: {
        g: 0,
        pg: 1,
        pg_13: 2,
        r: 3,
        nc_17: 4
    }
    
    def validate_audio_languages
        
        # This is not the greatest idea, but it works. Remove the empty string during validation
        audio_languages.reject! { |l| l.empty? }
        
        if !audio_languages.any?
            errors.add(:audio_languages, "need to select a language")
        end
        
        # If any of the audio languages is invalid, add the error and break
        audio_languages.each do |al|
            valid = false
            Language.languages.each do |l, i|
                puts "#{al.downcase} != #{l.downcase}"
                valid = true if (al.downcase == l.downcase)
            end
            
            if !valid
                errors.add(:audio_languages, "not a valid language selection")
                break
            end
        end
    end
end
