class AddYearAndSemesterToApplicationConfigurations < ActiveRecord::Migration
  def change
    add_column :application_configurations, :current_semester_year, :integer
    add_column :application_configurations, :current_semester, :integer
  end
end
