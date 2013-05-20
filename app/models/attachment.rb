class Attachment < ActiveRecord::Base
  self.primary_key=:id

  attr_accessible :id,:name,:path,:mime
  attr_accessor :id,:name,:path,:mime
end
