class RenameProjectViewableByToPublishBy < ActiveRecord::Migration[4.2]

def change
    rename_column :projects, :viewable_by, :publish_by
  end
end
