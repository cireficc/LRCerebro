class InventoryItem < ActiveRecord::Base

    belongs_to :inventoriable, polymorphic: true, dependent: :destroy

    # The catalog number is generated and set when the record is created
    validates :catalog_number, presence: true, unless: :new_record?
    validates :status, presence: true
    validates :inventoriable, presence: true, associated: true

    scope :films, -> { where(inventoriable_type: "Film") }
    scope :cds, -> { where(inventoriable_type: "CD") }
    scope :games, -> { where(inventoriable_type: "Game") }
    scope :equipment, -> { where(inventoriable_type: "Equipment") }

    before_create :set_catalog_number

    # Inventory status
    # :functional - Nothing is wrong with the item
    # :not_functional - The item is broken or not functional
    # :missing - The item is missing from the LRC
    enum status: {
        functional: 0,
        not_functional: 1,
        missing: 2
    }

    private

    def set_catalog_number
        generated = generate_catalog_number(inventoriable)
        puts "Catalog number: #{generated}"
        self.catalog_number = generated
    end

    # Generates the next catalog number for any given inventoriable item
    def generate_catalog_number(inventoriable)

        case inventoriable.class.name

        when "Film"

            prefix = "M"

            # Get the first character of the audio language that is not English
            language_character = inventoriable.audio_languages.reject { |l| l == "english" }.first[0]

            # Prefer the foreign title over the English one
            title_character = inventoriable.transliterated_foreign_title[0]

            final_prefix = "#{prefix}#{language_character}-#{title_character}".upcase

            # Find all films with similar prefixes
            matching_prefixes = InventoryItem.films.where("catalog_number LIKE ?",  "#{final_prefix}%").collect(&:catalog_number)

            if (matching_prefixes.any?)
                # Remove the prefix from the last entry
                last_catalog_number = matching_prefixes.last.sub(final_prefix, "")
                new_catalog_number = last_catalog_number.to_i + 1
            else
                new_catalog_number = 1
            end

            return "#{final_prefix}#{new_catalog_number}"

        when "CD"

            return "WIP"

        when "Game"

            return "WIP"

        when "Equipment"

            return "WIP"
        end
    end
end
