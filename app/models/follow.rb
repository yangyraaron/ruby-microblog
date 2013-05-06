
class Follow < ActiveRecord::Base
  self.primary_key=:id

  attr_accessible :id, :following_id, :user_id

  belongs_to :user

  def follow
    logger.info("follow user : #{self.inspect}")
    fan = Fan.new(:id=>IdGenerator.generate_id,:user_id=>self.following_id,:fans_id=>self.user_id)

    begin
      Follow.transaction do
        self.save
        fan.save

        User.update_counters [self.following_id],:fans_count=>1
        User.update_counters [self.user_id],:following_count=>1

      end
    rescue Exception => e
      logger.info("follow user with Exception : #{e.inspect}")
      return false
    end
    return true
  end

  def unfollow
    logger.info("unfollow : #{self.inspect}")
    fan = Fan.where(:user_id=>self.following_id,:fans_id=>self.user_id).first
    logger.info "unfans : #{fan.inspect}"

    unfollowing_user = User.find_by_user_id(self.following_id)
    user = User.find_by_user_id(self.user_id)

    begin
      Follow.transaction do
        self.destroy
        fan.destroy

        User.update_counters [self.following_id],:fans_count=>-1
        User.update_counters [self.user_id],:following_count=>-1

      end
    rescue Exception => e
      logger.info("unfollow user with Exception : #{e.inspect}")
      return false
    end
    return true

  end

end
