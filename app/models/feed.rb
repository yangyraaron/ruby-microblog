class Feed < ActiveRecord::Base
  before_create :generate_id

  attr_accessible :attach_id, :content, :creator_id, :id, :origin_feed_id

  def self.get_user_feeds(user_id)
  	self.where(["creator_id=?",user_id]).all
  end
  private
    def generate_id
      self.id = IdGenerator.generate_id
    end
end
