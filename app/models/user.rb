require 'digest/sha2'

class User < ActiveRecord::Base
  self.primary_key=:user_id

  has_many :follows
  has_many :fans

  validates :account,:email,:password,:presence=>true
  validates :account,:email,:uniqueness=>true
  validates :password,:confirmation=>true
  validates :email,:format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/, :on => :create }
  validate :password_must_be_present

  attr_accessible :account, :dynamic_desc, :email, :image_id, :user_id,:password_confirmation,:password,:is_following_by_current,:is_fans_of_current
  attr_accessor :password_confirmation
  attr_reader  :password

  def password=(password)
    @password=password

    if(password.present?)
      generate_salt
      self.hashed_password=self.class.encrpty_password(password,self.salt)
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

  def self.search(user_id,filter)
    if(filter.present?)
      like_filter="%#{filter}%"

      str_join = "LEFT JOIN follows ON follows.following_id=users.user_id AND follows.user_id=#{user_id} "
      str_join << "LEFT JOIN fans ON fans.fans_id=users.user_id AND fans.user_id=#{user_id}"

      str_select="users.*,"
      str_select << "CASE WHEN follows.user_id IS NULL THEN false ELSE true END is_following_by_current,"
      str_select << "CASE WHEN fans.user_id IS NULL THEN false ELSE true END is_fans_of_current"
      #self.where(["account like ? or email like ?",like_filter,like_filter])
      self.find(:all,
                :select=>str_select,
                :joins=>str_join,
                :conditions=>["users.account like ? or users.email like ?",like_filter,like_filter],
                :order=>"users.account"
                )
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
