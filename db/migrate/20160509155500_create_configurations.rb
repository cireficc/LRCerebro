class CreateConfigurations < ActiveRecord::Migration
  def change
    create_table :configurations do |t|
      t.text :enrollment_update_message
      t.datetime :enrollment_last_updated
      t.datetime :current_semester_start
      t.datetime :current_semester_end
      t.text :class_project_submission_start
      t.datetime :class_project_submission_end
      t.text :class_project_deadline_message
      t.timestamps null: false
    end
  end
end
