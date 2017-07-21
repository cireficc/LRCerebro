class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.belongs_to :course
      t.datetime :due_date
      t.text :instructions
      t.timestamps null: false
    end
  end
end
