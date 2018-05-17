class CreateInventoryItems < ActiveRecord::Migration[4.2]

def change
    create_table :inventory_items do |t|
      t.string :catalog_number
      t.string :catalog_code
      t.integer :status
      t.text :status_description
      t.text :notes
      t.belongs_to :inventoriable, polymorphic: true
      t.timestamps null: false
    end
    add_index :inventory_items, [:inventoriable_id, :inventoriable_type], name: "inventory_items_polymorphic_association_index"
  end
end
