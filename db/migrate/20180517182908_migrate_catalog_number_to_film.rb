class MigrateCatalogNumberToFilm < ActiveRecord::Migration[5.2]
  
  def change
    add_column :films, :catalog_number, :string
  end
end
