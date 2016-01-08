class AddIdToEnrollment < ActiveRecord::Migration
    def change
        add_column :enrollments, :id, :primary_key
    end
end
