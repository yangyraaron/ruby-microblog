class Feed < ActiveRecord::Base
  attr_accessible :attach_id, :content, :creator_id, :id, :origin_feed_id
end
