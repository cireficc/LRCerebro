class RenameCoursesUsersTable < ActiveRecord::Migration
    def self.up
        rename_table :courses_users, :enrollments
    end
  
    def self.down
        rename_table :enrollments, :courses_users
    end
end
