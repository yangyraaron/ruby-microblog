class CreateFans < ActiveRecord::Migration
  def self.up
    create_table :fans,:id=>false do |t|
    	t.integer :user_id,:null=>true,:limit=>8
    	t.integer :fans_id,:null=>true,:limit=>8

      t.timestamps
    end
     execute "ALTER TABLE fans ADD PRIMARY KEY (user_id,fans_id);"
  end

  def self.down
  	drop_table :fans
  end
end
