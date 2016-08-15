class CreateProjectGroups < ActiveRecord::Migration
  def change
    create_table :project_groups do |t|
      t.belongs_to :project
      t.string :publish_link
      t.timestamps null: false
    end
  end
end
