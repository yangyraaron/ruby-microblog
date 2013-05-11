class Group < ActiveRecord::Base

  # callback defination
  before_create :generate_id

  #database defination
  self.primary_key=:id
  has_and_belongs_to_many :users

  #mapping defination
  attr_accessible :id,:name,:description,:creator_id

  def self.get_follows(group_id,user_id)
    q_user_id=ActiveRecord::Base.connection.quote(user_id);

    group = self.find_by_id(group_id)

    str_select="users.*,"
    str_select << "CASE WHEN fs.user_id IS NULL THEN false ELSE true END is_fans_of_current"

    str_join="LEFT JOIN fans fs ON users.user_id=fs.fans_id AND fs.user_id=#{q_user_id}"
    
    group.users.all(
                     :select=>str_select,
                     :joins=>str_join,
                     :order=>"users.account")
  end

  def  self.get_groups(user_id)
     self.where(["creator_id=?",user_id]).order("name").all;
  end

  private
  def generate_id
    self.id = IdGenerator.generate_id
  end
end
