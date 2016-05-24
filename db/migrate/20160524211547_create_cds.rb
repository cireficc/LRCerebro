class CreateCds < ActiveRecord::Migration
  def change
    create_table :cds do |t|
      t.string :artist
      t.string :album
      t.integer :year
      t.text :tracks
      t.timestamps null: false
    end
  end
end
