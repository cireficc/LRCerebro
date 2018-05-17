class AddRegisteredToUsers < ActiveRecord::Migration[4.2]

def change
    add_column :users, :registered, :boolean
  end
end
