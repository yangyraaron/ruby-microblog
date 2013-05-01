
class Fan < ActiveRecord::Base
  self.primary_key=:id

  attr_accessible :id,:fans_id, :user_id

  belongs_to :user
end
