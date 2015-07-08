class CreateProjectReservations < ActiveRecord::Migration
  def change
    create_table :project_reservations do |t|
      t.belongs_to :project
      t.datetime :start
      t.datetime :end
      t.integer :lab
      t.integer :subtype
      t.text :staff_notes
      t.text :faculty_notes
      t.timestamps
    end
  end
end
