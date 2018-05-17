class CreateMiniProjects < ActiveRecord::Migration[4.2]

def change
    create_table :mini_projects do |t|
      t.belongs_to :course
      t.text :resources, array: true, default: []
      t.text :description
      t.boolean :supplemental_materials
      t.datetime :start_date
      t.datetime :due_date
      t.datetime :publish_by
      t.text :publish_methods, array: true, default: []
      t.timestamps null: false
    end
  end
end
