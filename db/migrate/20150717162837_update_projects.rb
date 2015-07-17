class UpdateProjects < ActiveRecord::Migration
  def change
    change_table :projects do |t|
      t.change :approved, :boolean, :default => false
      t.change :archived, :boolean, :default => false
    end
  end
end
