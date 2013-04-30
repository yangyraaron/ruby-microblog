class CreateFollows < ActiveRecord::Migration
  def self.up
    create_table :follows,:id=>false do |t|
      t.integer :user_id,:null=>true,:limit=>8
      t.integer :following_id,:null=>true,:limit=>8

      t.timestamps
    end
    execute "ALTER TABLE follows ADD PRIMARY KEY (user_id,following_id);"

  end

  def self.down
    drop_table :follows
  end
end
