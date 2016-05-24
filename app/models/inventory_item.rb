class InventoryItem < ActiveRecord::Base
    belongs_to :inventoriable, polymorphic: true
end
