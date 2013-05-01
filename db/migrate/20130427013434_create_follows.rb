class CreateFollows < ActiveRecord::Migration
  def self.up
    create_table :follows,:id=>false do |t|
      t.integer :id,:null=>false,:limit=>8
      t.integer :user_id,:null=>false,:limit=>8
      t.integer :following_id,:null=>false,:limit=>8

      t.timestamps
    end
    add_index :follows,:user_id
    add_index :follows,:following_id
    execute "ALTER TABLE follows ADD PRIMARY KEY (id);"

  end

  def self.down
    remove_index :follows,:user_id
    remove_index :follows,:following_id
    drop_table :follows
  end
end
