class AddTitleToDigitizedVersion < ActiveRecord::Migration
  def change
    add_column :digitized_versions, :english_title, :string
    add_column :digitized_versions, :foreign_title, :string
  end
end
