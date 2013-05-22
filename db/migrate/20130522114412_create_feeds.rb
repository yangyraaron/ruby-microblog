class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds,:id=>false do |t|
      t.integer :id,:null=>false,:limit=>8
      t.string :content
      t.integer :creator_id,:limit=>8
      t.integer :attach_id,:limit=>8
      t.integer :origin_feed_id, :limit=>8

      t.timestamps
    end
    add_index :feeds ,:creator_id
    execute "ALTER TABLE feeds ADD PRIMARY KEY (id);"
  end

  def  self.down
    remove_index :feeds,:creator_id
    drop_table :feeds
  end
end
