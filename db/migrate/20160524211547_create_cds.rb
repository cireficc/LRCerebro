class CreateCds < ActiveRecord::Migration[4.2]

def change
    create_table :cds do |t|
      t.integer :language
      t.string :artist
      t.string :album
      t.integer :year
      t.text :tracks
      t.timestamps null: false
    end
  end
end
