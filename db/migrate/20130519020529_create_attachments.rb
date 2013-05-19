class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments,:id=>false do |t|
      t.integer :id,:null=>false,:limit=>8
      t.string :name
      t.string :path
      t.string :mime

      t.timestamps
    end

    execute "ALTER TABLE attachments ADD PRIMARY KEY (id);"
  end
end
