require 'digest/sha2'

class User < ActiveRecord::Base
  self.primary_key='user_id'

  validates :account,:email,:password,:presence=>true
  validates :account,:email,:uniqueness=>true
  validates :password,:confirmation=>true
  validates :email,:format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/, :on => :create }
  validate :password_must_be_present

  attr_accessible :account, :dynamic_desc, :email, :image_id, :user_id,:password_confirmation,:password
  attr_accessor :password_confirmation
  attr_reader  :password

  def password=(password)
  	@password=password

  	if(password.present?)
  		generate_salt
  		self.hashed_password=self.class.encrpty_password(password,salt)
  	end
  end

  def self.encrpty_password(password,salt)
  	Digest::SHA2.hexdigest(password+salt)
  end

  def self.authenticate(account,password)
  	if user = find_by_account(account)
  		if encrpty_password(password,user.salt)==user.hashed_password
  			user
  		end
  	end
  end

  private
  	def password_must_be_present
  		errors.add(:password,"Missing a password") unless hashed_password.present?
  	end

  	def generate_salt
  		self.salt=self.user_id.to_s+rand.to_s
  	end

end
