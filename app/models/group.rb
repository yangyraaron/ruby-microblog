class Group < ActiveRecord::Base

  # callback defination
  before_save :generate_id

  #database defination
  self.primary_key=:id
  has_and_belongs_to_many :users

  #mapping defination
  attr_accessible :id,:name,:description

  def self.get_follows(group_id)
    group = self.find_by_id(group_id)

    str_select="users.*,"
    str_select << "CASE WHEN fs.user_id IS NULL THEN false ELSE true END is_fans_of_current"

    str_join="LEFT JOIN fans fs ON users.user_id=fs.fans_id"

    group.users.find(:all,
                     :select=>str_select,
                     :joins=>str_join,
                     :conditions=>["groups_users.group_id=?",group_id],
                     :order=>"users.account")
  end

  private
  def generate_id
    self.id = IdGenerator.generate_id
  end
end
