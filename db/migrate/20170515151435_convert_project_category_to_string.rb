class ConvertProjectCategoryToString < ActiveRecord::Migration
  def change
    change_column :projects, :category, :string

    # Mapping for int enum values to string representation
    project_categories = {
        0 => "Camtasia",
        1 => "Garage Band",
        2 => "Pixton",
        3 => "Photo Booth",
        4 => "Blog",
        5 => "Pages",
        6 => "Other",
        7 => "Storybird"
    }
    
    # Convert the old enum ints to their new string representation
    Project.all.each do |p|
      int = p[:category].to_i
      p.update_columns(category: project_categories[int])
    end
  end
end
