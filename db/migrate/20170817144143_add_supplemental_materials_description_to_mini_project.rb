class AddSupplementalMaterialsDescriptionToMiniProject < ActiveRecord::Migration[4.2]

def change
    add_column :mini_projects, :supplemental_materials_description, :text
  end
end
