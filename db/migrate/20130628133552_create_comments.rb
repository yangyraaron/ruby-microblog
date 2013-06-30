class CreateComments < ActiveRecord::Migration
  def up
  	create_table :comments,:id=>false do |t|
  		t.integer :id,:null=>false,:limit=>8
  		t.string :content
  		t.integer :creator_id,:limit=>8
  		t.integer :feed_id,:null=>false,:limit=>8
  		t.integer :reply_comment_id,:limit=>8

  		t.timestamps
  	end

  	add_index :comments,:feed_id
  	execute "ALTER TABLE comments ADD PRIMARY KEY (id);"
  end

  def down
  	remove_index :comments,:feed_id
  	drop_table :comments
  end
end
