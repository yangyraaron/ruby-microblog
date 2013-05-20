require 'date'

class AttachmentFile
	@@root_dir=Rails.root.join('attachments')

	def self.save(name,content)
		folder = self.check_dir

		file_path = "#{File.join(@@root_dir,folder,name)}"
		File.open(file_path, "wb") do |f|
			f.write(content)
		end

		folder
	end

	def self.get(name,path)
		content=[]

		file_path=="#{File.join(@@root_dir,folder,name)}"
		File.open(file_path, "r") do |f|
			f.each_byte do |b|
				content<<b
			end
		end

		content
	end

	protected
	def self.check_dir
		if !Dir.exist?(@@root_dir)
			Dir.mkdir(@@root_dir)
		end

		child_folder=Date.today.to_s
		folder = File.join(@@root_dir,child_folder)
		
		if !Dir.exist?(folder)
			Dir.mkdir(folder) 
		end

		child_folder
	end
end