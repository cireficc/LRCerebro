class AddProducteevToggleToProject < ActiveRecord::Migration
  def change
    add_column :projects, :added_to_producteev, :boolean
  end
end
