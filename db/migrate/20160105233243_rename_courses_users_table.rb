class RenameCoursesUsersTable < ActiveRecord::Migration[4.2]

def self.up
        rename_table :courses_users, :enrollments
    end
  
    def self.down
        rename_table :enrollments, :courses_users
    end
end
