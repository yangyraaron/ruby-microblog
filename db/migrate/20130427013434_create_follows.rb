class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows,:id=>false do |t|
      t.integer :user_id,:null=>true,:limit=>8
      t.integer :following_id,:null=>true,:limit=>8

      t.timestamps
    end
    execute "ALTER TABLE follows ADD PRIMARY KEY (user_id,following_id);"

    create_table :fans,:id=>false do |t|
      t.integer :user_id,:null=>true,:limit=>8
      t.integer :fan_id,:null=>true,:limit=>8


      t.timestamps
    end
    execute "ALTER TABLE fans ADD PRIMARY KEY (user_id,fan_id);"
  end
end
