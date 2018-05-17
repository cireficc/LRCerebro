class AddProducteevToggleToProject < ActiveRecord::Migration[4.2]

def change
    add_column :projects, :added_to_producteev, :boolean
  end
end
