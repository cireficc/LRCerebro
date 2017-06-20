class AddPublishMethodToProject < ActiveRecord::Migration
  def change
    add_column :projects, :publish_methods, :text, array: true, default: []
  end
end
