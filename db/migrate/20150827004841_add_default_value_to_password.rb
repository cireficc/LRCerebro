class AddDefaultValueToPassword < ActiveRecord::Migration[4.2]

def change
      change_column_default(:users, :password_digest, 'default')
  end
end
