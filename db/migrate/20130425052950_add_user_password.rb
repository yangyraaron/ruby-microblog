class AddUserPassword < ActiveRecord::Migration
  def self.up
  	#the arguments: table,column,type
  	add_column :users, :password,:string
  end

  def self.down
  	remove_column :users, :password,:string
  end
end
