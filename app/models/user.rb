class User < ActiveRecord::Base
  validates :account,:email,:password,:presence=>true
  validates :account,:email,:uniqueness=>true
  validates :email,:format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/, :on => :create }

  attr_accessible :account, :dynamic_desc, :email, :image_id, :user_id,:password

end
