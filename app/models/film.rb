class Film < ActiveRecord::Base
    has_one :inventory_item, as: :inventoriable, dependent: :destroy
    
    validates :film_type, :audio_languages, :subtitle_languages, :year, :length, :mpaa_rating, presence: true
    
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
end
