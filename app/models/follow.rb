
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
      end
    rescue Exception => e
    	logger.info("follow user with Exception : #{e.inspect}")
    	return false
    end
    return true
  end

end
