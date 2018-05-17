class AddMiniProjectColumnToProjects < ActiveRecord::Migration[4.2]

def change
      add_column :project_reservations, :mini_project, :boolean
  end
end
