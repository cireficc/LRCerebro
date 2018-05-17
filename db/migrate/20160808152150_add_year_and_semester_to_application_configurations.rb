class AddYearAndSemesterToApplicationConfigurations < ActiveRecord::Migration[4.2]

def change
    add_column :application_configurations, :current_semester_year, :integer
    add_column :application_configurations, :current_semester, :integer
  end
end
