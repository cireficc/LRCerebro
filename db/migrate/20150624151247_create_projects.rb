class CreateProjects < ActiveRecord::Migration[4.2]

def change
    create_table :projects do |t|
      t.belongs_to :course
      t.string :name
      t.text :description
      t.integer :category
      t.integer :num_groups
      t.timestamp :script_due
      t.timestamp :due
      t.timestamp :viewable_by
      t.boolean :approved
      t.string :publish_link
      t.boolean :archived
      t.timestamp :archived_at
      t.timestamps
    end
  end
end
