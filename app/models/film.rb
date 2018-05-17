class Film < ActiveRecord::Base
  searchkick word_start: [:english_title, :foreign_title, :transliterated_foreign_title, :catalog_number]

  has_many :digitized_versions, dependent: :destroy
  accepts_nested_attributes_for :digitized_versions, reject_if: :all_blank, :allow_destroy => true
  acts_as_taggable
  acts_as_taggable_on :directors, :cast_members, :genres
  mount_uploader :cover, FilmCoverUploader

  # The catalog number is generated and set when the record is created
  validates :catalog_number, presence: true, unless: :new_record?
  validates :catalog_number, uniqueness: true
  validates :film_type, :mpaa_rating, :audio_languages, presence: true
  validates :year, :length, numericality: { only_integer: true }
  validate :validate_title
  validates_associated :digitized_versions

  # Languages is an array which will always have an empty element, so get rid of it
  before_validation :reject_empty_languages
  before_create :set_catalog_number

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
        catalog_number: catalog_number,
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

  def reject_empty_languages
    audio_languages.reject! { |l| l.empty? }
    subtitle_languages.reject! { |l| l.empty? }
  end

  def validate_title
    if foreign_title.blank? || transliterated_foreign_title.blank?
      errors.add(:foreign_title, "Foreign title and transliterated foreign title must not be blank")
      errors.add(:transliterated_foreign_title, "Foreign title and transliterated foreign title must not be blank")
    end
  end

  def set_catalog_number
    prefix = 'M'

    # Get the first character of the audio language that is not English
    language_character = audio_languages.reject { |l| l.eql?('english') }.first[0]

    # Prefer the foreign title over the English one
    title_character = transliterated_foreign_title.strip[0]

    final_prefix = "#{prefix}#{language_character}-#{title_character}".upcase

    # Find all films with similar prefixes
    matching_prefixes = Film.where('catalog_number LIKE ?',  "#{final_prefix}%").collect(&:catalog_number)

    if matching_prefixes.any?
      # Remove the prefix from the last entry
      last_catalog_number = matching_prefixes.last.sub(final_prefix, '')
      new_catalog_number = last_catalog_number.to_i + 1
    else
      new_catalog_number = 1
    end

    generated = "#{final_prefix}#{new_catalog_number}"
    puts "Catalog number: #{generated}"
    self.catalog_number = generated
  end
end
