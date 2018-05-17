class MigrateCatalogNumberToFilm < ActiveRecord::Migration[5.2]
  
  def change
    add_column :films, :catalog_number, :string
    
    film_inventory = InventoryItem.films
    film_inventory.each do |i|
      film = Film.find(i.inventoriable_id)
      film.update_column(:catalog_number, i.catalog_number)
    end
  end
end
