class AddPublishMethodToProject < ActiveRecord::Migration[4.2]

def change
    add_column :projects, :publish_methods, :text, array: true, default: []
  end
end
