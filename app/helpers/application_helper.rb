module ApplicationHelper
	def append_query_param(path,params)
		url = "#{path}"
		if(url=~/[\?]{1}[^\?]+/)
			url<<"&"
		else
			url<<"?"
		end
		
		i=0
		params.each do |key,value|
			unless i==0
				url <<"&#{key}=#{value}"
			else
				url<<"#{key}=#{value}" 
			end

			i=1
		end

		url

	end
end
