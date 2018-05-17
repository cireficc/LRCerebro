class CreateWorks < ActiveRecord::Migration[4.2]

def change
    create_table :works do |t|
      t.belongs_to :course
      t.datetime :due_date
      t.text :instructions
      t.timestamps null: false
    end
  end
end
