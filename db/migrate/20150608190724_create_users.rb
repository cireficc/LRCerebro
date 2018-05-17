class CreateUsers < ActiveRecord::Migration[4.2]

def change
    create_table :users do |t|
      t.string :username
      t.string :g_number
      t.string :password_digest
      t.timestamps
    end
  end
end
