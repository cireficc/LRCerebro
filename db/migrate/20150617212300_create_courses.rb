class CreateCourses < ActiveRecord::Migration[4.2]

def change
    create_table :courses do |t|
      t.integer :year
      t.integer :semester
      t.integer :department
      t.integer :course
      t.integer :section
      t.string :name
    end
  end
end
