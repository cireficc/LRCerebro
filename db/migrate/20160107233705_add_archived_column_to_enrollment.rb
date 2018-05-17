class AddArchivedColumnToEnrollment < ActiveRecord::Migration[4.2]

def change
      add_column :enrollments, :archived, :boolean, default: false
  end
end
