class Attachment < ActiveRecord::Base
  # attr_accessible :title, :body

  attr_accessor :id,:name,:path,:mime
end
