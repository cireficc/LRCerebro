class AddArchivedColumnToEnrollment < ActiveRecord::Migration
  def change
      add_column :enrollments, :archived, :boolean, default: false
  end
end
