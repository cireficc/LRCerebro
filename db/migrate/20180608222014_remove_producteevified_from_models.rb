class RemoveProducteevifiedFromModels < ActiveRecord::Migration[5.2]
	def change
		remove_column :projects, :added_to_producteev
		remove_column :mini_projects, :added_to_producteev
		remove_column :film_digitizations, :added_to_producteev
		remove_column :vidcams, :added_to_producteev
		remove_column :works, :added_to_producteev
	end
end
