class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, :id=>false do |t|
      #the type of user_id is long
      t.integer :user_id,:null=>false, :limit=>8
      t.string :account,:null=>false
      t.string :password,:null=>false
      t.string :email,:null=>false
      t.string :dynamic_desc
      t.integer :image_id,:limit=>8
      t.integer :msg_count, :limit=>8
      t.integer :fans_count
      t.integer :following_count

      t.timestamps
    end

    execute "ALTER TABLE users ADD PRIMARY KEY (user_id);"
  end
end
