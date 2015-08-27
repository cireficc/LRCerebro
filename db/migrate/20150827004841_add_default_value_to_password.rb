class AddDefaultValueToPassword < ActiveRecord::Migration
  def change
      change_column_default(:users, :password_digest, 'default')
  end
end
