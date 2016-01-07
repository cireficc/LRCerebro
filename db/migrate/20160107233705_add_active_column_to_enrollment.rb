class AddActiveColumnToEnrollment < ActiveRecord::Migration
  def change
      add_column :enrollments, :active, :boolean, default: true
  end
end
