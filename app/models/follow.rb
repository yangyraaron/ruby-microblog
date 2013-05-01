
class Follow < ActiveRecord::Base
  self.primary_key=:id

  attr_accessible :id, :following_id, :type, :user_id

  belongs_to :user

end
