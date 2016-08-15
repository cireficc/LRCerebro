class CreateProjectGroupMembers < ActiveRecord::Migration
  def change
    create_table :project_group_members do |t|
      t.belongs_to :project_group
      t.belongs_to :user
      t.timestamps null: false
    end
  end
end
