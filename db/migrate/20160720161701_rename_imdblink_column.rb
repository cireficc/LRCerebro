class RenameImdblinkColumn < ActiveRecord::Migration[4.2]

def change
    rename_column :films, :imdb_link, :more_info_link
  end
end
