class Feed < ActiveRecord::Base
  before_save :generate_id,:default_values

  attr_accessible :attach_id, :content, :creator_id, :id, :origin_feed_id,
    :forward_count,:comment_count,
    :creator_account,:creator_image_id,
    :origin_feed

  attr_reader :origin_feed

  def self.get_user_feeds(user_id,page={:size=>10,:index=>1})
    conditions = ["creator_id=?",user_id]
    count = self.count(:conditions=>conditions)
    offset = page[:size]*(page[:index]-1)

    feeds = self.where(conditions)
    .order('created_at DESC')
    .limit(page[:size])
    .offset(offset)
    .all

    feeds.each do |f|
      f.init_origin_feed
    end

    {:feeds=>feeds,:count=>count}
  end

  def self.get_feeds(user_id,page={:size=>10,:index=>1})
    offset = page[:size]*(page[:index]-1)

    select = "feeds.*,users.account creator_account,users.image_id creator_image_id"
    join = "LEFT JOIN users on feeds.creator_id=users.user_id"
    conditions=["feeds.creator_id in (SELECT following_id FROM follows WHERE follows.user_id=?) OR feeds.creator_id=?",user_id,user_id]

    count = self.count(:conditions=>conditions)

    feeds = self.all({:select=>select,:joins=>join,:conditions=>conditions,
                      :order=>'created_at DESC',:limit=>page[:size],:offset=>offset})

    feeds.each do |feed|
      feed.init_origin_feed
    end

    {:feeds=>feeds,:count=>count}

  end

  def origin_feed=(feed)
    @origin_feed=feed
  end

  def init_origin_feed
    if(!self.origin_feed_id.nil?)
      self.origin_feed = get_feed_ex
    end
  end

  def get_feed_ex
    select = "feeds.*,users.account creator_account,users.image_id creator_image_id"
    join = "LEFT JOIN users on feeds.creator_id=users.user_id"
    conditions=["feeds.id=? ",self.origin_feed_id]

    Feed.all(:select=>select,:joins=>join,:conditions=>conditions).first;
  end

  def this_id
    self.id.to_s
  end

  def origin_id
    self.origin_feed_id.to_s
  end

  def origin_feed_json
    self.origin_feed.as_json
  end

  private
    def generate_id
      self.id = IdGenerator.generate_id
    end

    def default_values
      self.forward_count ||=0;
      self.comment_count ||=0;
    end
end
