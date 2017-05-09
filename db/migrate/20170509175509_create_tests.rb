class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.string :string_enum
      t.string :string_enum_other
      t.timestamps null: false
    end
  end
end
