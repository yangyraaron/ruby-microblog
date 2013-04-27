class Follow < ActiveRecord::Base
  attr_accessible :following_id, :type, :user_id
end
