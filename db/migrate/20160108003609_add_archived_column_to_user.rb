class AddArchivedColumnToUser < ActiveRecord::Migration[4.2]

def change
        add_column :users, :archived, :boolean, default: false
    end
end
