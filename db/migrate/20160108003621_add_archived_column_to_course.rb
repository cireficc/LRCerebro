class AddArchivedColumnToCourse < ActiveRecord::Migration
    def change
        add_column :courses, :archived, :boolean, default: false
    end
end
