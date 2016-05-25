class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :english_title
      t.string :foreign_title
      t.text :audio_languages, array: true, default: []
      t.text :subtitle_languages, array: true, default: []
      t.integer :platform
      t.timestamps null: false
    end
  end
end
