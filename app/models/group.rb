class Group < ActiveRecord::Base

  # callback defination
  before_save :generate_id

  #database defination
  self.primary_key=:id
  has_and_belongs_to_many :users

  #mapping defination
  attr_accessible :id,:name,:description

  private
  def generate_id
    self.id = IdGenerator.generate_id
  end
end
