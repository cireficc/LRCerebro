class CreateFilms < ActiveRecord::Migration
  def change
    create_table :films do |t|
      t.integer :film_type
      t.string :english_title
      t.string :foreign_title
      t.text :description
      t.text :audio_languages, array: true, default: []
      t.text :subtitle_languages, array: true, default: []
      # :directors (acts_as_taggable)
      # :cast_members (acts_as_taggable)
      # :genres (acts_as_taggable)
      t.integer :year
      t.integer :length
      t.integer :mpaa_rating
      t.timestamps null: false
    end
  end
end
