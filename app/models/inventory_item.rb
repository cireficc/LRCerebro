class InventoryItem < ActiveRecord::Base
    
    belongs_to :inventoriable, polymorphic: true, dependent: :destroy
    
    validates :catalog_number, :status, presence: true
    validates :inventoriable, presence: true, associated: true
    
    scope :films, -> { where(inventoriable_type: "Film") }
    scope :cds, -> { where(inventoriable_type: "CD") }
    scope :games, -> { where(inventoriable_type: "Game") }
    scope :equipment, -> { where(inventoriable_type: "Equipment") }
    
    # Inventory status
    # :functional - Nothing is wrong with the item
    # :not_functional - The item is broken or not functional
    # :missing - The item is missing from the LRC
    enum status: {
        functional: 0,
        not_functional: 1,
        missing: 2
    }
end
