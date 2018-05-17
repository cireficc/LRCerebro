class AddTitleToDigitizedVersion < ActiveRecord::Migration[4.2]

def change
    add_column :digitized_versions, :english_title, :string
    add_column :digitized_versions, :foreign_title, :string
  end
end
