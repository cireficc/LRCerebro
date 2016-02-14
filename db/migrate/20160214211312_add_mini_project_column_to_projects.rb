class AddMiniProjectColumnToProjects < ActiveRecord::Migration
  def change
      add_column :project_reservations, :mini_project, :boolean
  end
end
