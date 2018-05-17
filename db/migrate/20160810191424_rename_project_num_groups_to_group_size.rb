class RenameProjectNumGroupsToGroupSize < ActiveRecord::Migration[4.2]

def change
    rename_column :projects, :num_groups, :group_size
  end
end
