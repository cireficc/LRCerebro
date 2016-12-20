class RenameGNumberToPitm < ActiveRecord::Migration
  def change
    rename_column :users, :g_number, :pitm
  end
end
