class RenamePassword < ActiveRecord::Migration
  def up
  	rename_column :users, :password,:hashed_password
  	add_column :users, :salt,:string
  	add_index :users,:account,:unique=>true
  end

  def down
  	rename_column :users,:hashed_password,:password
  	remove_column :users,:salt
  	remove_index :users,:account
  end
end
