class AddCountsToFeeds < ActiveRecord::Migration
  def up
  	add_column :feeds, :forward_count,:integer
  	add_column :feeds, :comment_count,:integer
  end

  def down
  	remove_column :feeds, :forward_count
  	remove_column :feeds, :comment_count	
  end
end
