class RenameProjectNumGroupsToGroupSize < ActiveRecord::Migration
  def change
    rename_column :projects, :num_groups, :group_size
  end
end
