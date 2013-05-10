module GroupsHelper
	def model_path(group)
		if group == nil
			groups_path
		else
			group_path(group.id)
		end

	end
end
