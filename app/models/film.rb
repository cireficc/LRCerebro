class Film < ActiveRecord::Base
    searchkick autocomplete: [:english_title, :foreign_title, :transliterated_foreign_title, :catalog_number]

    has_one :inventory_item, as: :inventoriable, dependent: :destroy
    acts_as_taggable
    acts_as_taggable_on :directors, :cast_members, :genres
    mount_uploader :cover, FilmCoverUploader

    validates :film_type, :mpaa_rating, presence: true
    validates :year, :length, numericality: { only_integer: true }
    validate :validate_title
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
    # :nr Not rated (the MPAA hasn't rated the film yet)
    enum mpaa_rating: {
        g: 0,
        pg: 1,
        pg_13: 2,
        r: 3,
        nc_17: 4,
        nr: 5
    }

    def search_data
        {
            catalog_number: inventory_item.catalog_number,
            english_title: english_title,
            foreign_title: foreign_title,
            transliterated_foreign_title: transliterated_foreign_title,
            audio_languages: audio_languages,
            subtitle_languages: subtitle_languages,
            description: description,
            director_list: directors.collect(&:name),
            cast_member_list: cast_members.collect(&:name),
            genre_list: genres.collect(&:name)
        }
    end

    def validate_title
        if foreign_title.blank? && transliterated_foreign_title.blank?
            errors.add(:foreign_title, "Foreign title and transliterated foreign title must not be blank")
            errors.add(:transliterated_foreign_title, "Foreign title and transliterated foreign title must not be blank")
        end
    end

    def validate_audio_languages
        error = Language.validate_languages(audio_languages)
        errors.add(:audio_languages, error) if error
    end
end
