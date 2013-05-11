class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups,:id=>false do |t|
      t.integer :id,:null=>false,:limit=>8
      t.string :name,:null=>false
      t.string :description
      t.timestamps
    end

    execute "ALTER TABLE groups ADD PRIMARY KEY (id);"

    create_table :groups_users,:id=>false do |t|
      t.integer :group_id,:null=>false,:limit=>8
      t.integer :user_id,:null=>false,:limit=>8
    end

    add_index :groups_users, :group_id
    add_index :groups_users,:user_id
  end

  def self.down
    remove_index :groups_users,:group_id
    remove_index :groups_users,:user_id
  	
    drop_table :groups
    drop_table :groups_users
  end
end
