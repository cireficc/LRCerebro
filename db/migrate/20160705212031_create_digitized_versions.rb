class CreateDigitizedVersions < ActiveRecord::Migration
  def change
    create_table :digitized_versions do |t|
      t.belongs_to :film
      t.integer :audio_language
      t.integer :subtitle_language
      t.string :direct_link
      t.text :embed_code
      t.timestamps null: false
    end
  end
end
