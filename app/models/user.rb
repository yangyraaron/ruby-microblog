class User < ActiveRecord::Base
  attr_accessible :account, :dynamic_desc, :email, :image_id, :user_id
end
