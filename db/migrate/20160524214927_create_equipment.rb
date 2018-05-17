class CreateEquipment < ActiveRecord::Migration[4.2]

def change
    create_table :equipment do |t|
      t.integer :equipment_type
      t.timestamps null: false
    end
  end
end
