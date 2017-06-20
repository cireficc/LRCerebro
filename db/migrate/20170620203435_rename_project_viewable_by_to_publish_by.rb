class RenameProjectViewableByToPublishBy < ActiveRecord::Migration
  def change
    rename_column :projects, :viewable_by, :publish_by
  end
end
