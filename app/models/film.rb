class Film < ActiveRecord::Base
    has_one :inventory_item, as: :inventoriable, dependent: :destroy
end
