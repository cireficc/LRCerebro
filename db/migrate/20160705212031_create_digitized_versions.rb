class CreateDigitizedVersions < ActiveRecord::Migration[4.2]

def change
    create_table :digitized_versions do |t|
      t.belongs_to :film
      t.string :audio_language
      t.string :subtitle_language
      t.string :direct_link
      t.text :embed_code
      t.timestamps null: false
    end
  end
end
