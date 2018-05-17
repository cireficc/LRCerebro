class AddProducteevToggleToRequestForms < ActiveRecord::Migration[4.2]

def change
    add_column :mini_projects, :added_to_producteev, :boolean
    add_column :film_digitizations, :added_to_producteev, :boolean
    add_column :vidcams, :added_to_producteev, :boolean
    add_column :works, :added_to_producteev, :boolean
  end
end
