class UpdateProjects < ActiveRecord::Migration[4.2]

def change
    change_table :projects do |t|
      t.change :approved, :boolean, :default => false
      t.change :archived, :boolean, :default => false
    end
  end
end
