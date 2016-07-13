class AddImdbToFilms < ActiveRecord::Migration
  def change
    add_column :films, :imdb_link, :string
  end
end
