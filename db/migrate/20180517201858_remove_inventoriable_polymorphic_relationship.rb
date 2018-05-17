class RemoveInventoriablePolymorphicRelationship < ActiveRecord::Migration[5.2]
	
	def up
		drop_table :cds
		drop_table :equipment
		drop_table :games
		drop_table :inventory_items
	end

	def down
		fail ActiveRecord::IrreversibleMigration
	end
end
