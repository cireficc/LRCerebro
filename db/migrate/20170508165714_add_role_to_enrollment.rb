class AddRoleToEnrollment < ActiveRecord::Migration
  def change
    add_column :enrollments, :role, :integer
  end
end
