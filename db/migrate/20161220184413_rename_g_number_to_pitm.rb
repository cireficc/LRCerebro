class RenameGNumberToPitm < ActiveRecord::Migration[4.2]

def change
    rename_column :users, :g_number, :pitm
  end
end
