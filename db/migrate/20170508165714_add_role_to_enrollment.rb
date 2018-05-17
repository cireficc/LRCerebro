class AddRoleToEnrollment < ActiveRecord::Migration[4.2]

def change
    add_column :enrollments, :role, :integer
  end
end
