class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :language
      t.integer :platform
      t.string :title
      t.timestamps null: false
    end
  end
end
