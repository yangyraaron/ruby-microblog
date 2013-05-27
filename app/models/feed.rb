class Feed < ActiveRecord::Base
  before_create :generate_id

  attr_accessible :attach_id, :content, :creator_id, :id, :origin_feed_id

  def self.get_user_feeds(user_id,page={:size=>10,:index=>0})
  	conditions = ["creator_id=?",user_id]
  	count = self.count(:conditions=>conditions)

  	feeds = self.where(conditions)
  		.order('created_at DESC')
  		.limit(page[:size])
  		.offset(page[:index])
  		.all
  	{:feeds=>feeds,:count=>count}
  end
  private
    def generate_id
      self.id = IdGenerator.generate_id
    end
end
