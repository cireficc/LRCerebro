class AddSupplementalMaterialsDescriptionToMiniProject < ActiveRecord::Migration
  def change
    add_column :mini_projects, :supplemental_materials_description, :text
  end
end
