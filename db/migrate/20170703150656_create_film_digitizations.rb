class CreateFilmDigitizations < ActiveRecord::Migration
  def change
    create_table :film_digitizations do |t|
      t.belongs_to :course
      t.belongs_to :film
      t.datetime :due_date
      t.string :media_source
      t.string :film_title
      t.string :audio_language
      t.string :subtitle_language
      t.text :additional_instructions
      t.timestamps null: false
    end
  end
end
