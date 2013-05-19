require 'date'

class FileAttachment
	@@root_dir=Rails.root.join('attachments')

	def self.save(id,content,mime_type)
		folder = self.check_dir

		file_path = "#{File.join(@@root_dir,folder,id)}.#{mime_type}"
		File.open(file_path, "w")do |f|
			content.each do |b|
				str_b = [b].pack("C")
				f<<str_b
			end
		end

		folder
	end

	def self.get(id,path,mime_type)
		folder = self.check_dir
		content=[]

		file_path=="#{File.join(@@root_dir,folder,id)}.#{mime_type}"
		File.open(file_path, "r") do |f|
			f.each_byte do |b|
				content<<b
			end
		end

		content
	end

	protected
	def self.check_dir
		child_folder=Date.today.to_s
		folder = File.join(@root_dir,child_folder)
		
		if !Dir.exist?(folder)
			Dir.mkdir(folder)
		end

		child_folder
	end
end