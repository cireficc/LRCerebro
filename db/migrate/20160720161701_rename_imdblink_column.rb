class RenameImdblinkColumn < ActiveRecord::Migration
  def change
    rename_column :films, :imdb_link, :more_info_link
  end
end
