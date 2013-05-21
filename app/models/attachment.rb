class Attachment < ActiveRecord::Base
  self.primary_key=:id

  attr_accessible :id,:name,:path,:mime,:ext
end
