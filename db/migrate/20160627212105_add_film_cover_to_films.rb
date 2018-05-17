class AddFilmCoverToFilms < ActiveRecord::Migration[4.2]

def change
    add_column :films, :cover, :string
  end
end
