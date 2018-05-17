class AddImdbToFilms < ActiveRecord::Migration[4.2]

def change
    add_column :films, :imdb_link, :string
  end
end
