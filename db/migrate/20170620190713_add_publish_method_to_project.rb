class AddPublishMethodToProject < ActiveRecord::Migration
  def change
    add_column :projects, :publish_method, :text, array: true, default: []
  end
end
