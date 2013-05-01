class CreateFans < ActiveRecord::Migration
  def self.up
    create_table :fans,:id=>false do |t|
      t.integer :id,:null=>false,:limit=>8
      t.integer :user_id,:null=>false,:limit=>8
      t.integer :fans_id,:null=>false,:limit=>8

      t.timestamps
    end
    add_index :fans,:user_id
    add_index :fans,:fans_id
    execute "ALTER TABLE fans ADD PRIMARY KEY (id);"
  end

  def self.down
    remove_index :fans,:user_id
    remove_index :fans,:fans_id
    drop_table :fans
  end
end
