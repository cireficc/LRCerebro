class RenamePasswordDigestToEncryptedPassword < ActiveRecord::Migration[4.2]

def change
    rename_column :users, :password_digest, :encrypted_password
  end
end
