class RemoveArchiveColumns < ActiveRecord::Migration
  def change
    remove_column :users, :archived
    remove_column :courses, :archived
    remove_column :enrollments, :archived
    remove_column :projects, :archived
    remove_column :projects, :archived_at
  end
end
