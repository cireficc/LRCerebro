class InventoryItem < ActiveRecord::Base
    
    belongs_to :inventoriable, polymorphic: true
    
    scope :films, -> { where(inventoriable_type: "Film") }
    scope :cds, -> { where(inventoriable_type: "CD") }
    scope :games, -> { where(inventoriable_type: "Game") }
    scope :equipment, -> { where(inventoriable_type: "Equipment") }
end
