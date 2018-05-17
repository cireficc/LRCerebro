class AddTimestamps < ActiveRecord::Migration[4.2]

def change
      add_column :courses, :created_at, :datetime
      add_column :courses, :updated_at, :datetime
      add_column :enrollments, :created_at, :datetime
      add_column :enrollments, :updated_at, :datetime
  end
end
