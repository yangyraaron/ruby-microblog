class AddCreatorIdToGroups < ActiveRecord::Migration
  class Group < ActiveRecord::Base
  	self.primary_key=:id
  	attr_accessible :creator_id
  end

  def change
    add_column :groups,:creator_id,:integer,:limit=>8

    Group.reset_column_information
    Group.all.each do |group|
      group.update_attributes!(:creator_id=>"267429992944631808")
    end
  end
end
