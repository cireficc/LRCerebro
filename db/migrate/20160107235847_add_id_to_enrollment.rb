class AddIdToEnrollment < ActiveRecord::Migration[4.2]

def change
        add_column :enrollments, :id, :primary_key
    end
end
