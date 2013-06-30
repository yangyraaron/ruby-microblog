class Comment < ActiveRecord::Base
	before_save :generate_id
	
	attr_accessible :id,:content,:creator_id,:feed_id,:reply_comment_id,
					:creator_account,:creator_img_id

	def self.get_feed_comments(feed_id)
		select = "comments.*,users.account creator_account,users.image_id creator_img_id"
		join = "LEFT JOIN users on comments.creator_id=users.user_id"
		conditions = ["comments.feed_id=?",feed_id]

		self.all({:select=>select,:joins=>join,:conditions=>conditions,
			:order=>'created_at DESC'})
	end

	private 
	def generate_id
		self.id = IdGenerator.generate_id
	end
end