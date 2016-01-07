class ChangeEnrollmentsColumnType < ActiveRecord::Migration
  def self.up
        change_column :enrollments, :user_id, :string
    end
  
    def self.down
        change_column :enrollments, :user_id, :integer
    end
end
