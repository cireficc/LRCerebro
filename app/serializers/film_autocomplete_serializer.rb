class FilmAutocompleteSerializer < ActiveModel::Serializer
    attributes :english_title, :foreign_title, :title, :transliterated_foreign_title, :description, :audio_languages,
                :subtitle_languages, :year, :length, :catalog_number, :cover_thumb

    def title
        ft, et = object.foreign_title, object.english_title
        (et.present?) ? "#{ft} (#{et})" : ft
    end

    # A 147-character-length max description plus "..." for 150 characters
    def description
        object.short_description
    end

    def audio_languages
        object.audio_languages.map{ |l| l.titleize }
    end

    def subtitle_languages
        object.subtitle_languages.map{ |l| l.titleize }
    end

    def catalog_number
        object.inventory_item.catalog_number
    end

    def cover_thumb
        object.cover_url(:thumb)
    end
end
