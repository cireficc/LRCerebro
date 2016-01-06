class ChangeUserIdJoinColumn < ActiveRecord::Migration
    def self.up
        #change_column :courses_users, :user_id, :string
        rename_table :courses_users, :enrollments
    end
  
    def self.down
        rename_table :enrollments, :courses_users
        #change_column :courses_users, :user_id, :integer
    end
end
