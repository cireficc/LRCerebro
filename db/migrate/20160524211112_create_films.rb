class CreateFilms < ActiveRecord::Migration
  def change
    create_table :films do |t|
      t.integer :film_type
      t.string :english_title
      t.string :foreign_title
      t.text :description
      t.text :audio_languages, array: true, default: []
      t.text :subtitle_languages, array: true, default: []
      t.text :directors, array: true, default: []
      t.text :cast_members, array: true, default: []
      # :genres (acts_as_taggable)
      t.integer :year
      t.integer :length
      t.string :mpaa_raing
      t.timestamps null: false
    end
  end
end
