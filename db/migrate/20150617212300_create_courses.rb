class CreateCourses < ActiveRecord::Migration
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
