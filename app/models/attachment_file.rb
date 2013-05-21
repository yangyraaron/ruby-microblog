require 'date'

class AttachmentFile
	@@root_dir=Rails.root.join('attachments')
	@@default_dir=Rails.root.join('app','assets','images','gravatar-user-420.png')

	def self.save(name,content)
		folder = self.check_dir

		file_path = "#{File.join(@@root_dir,folder,name)}"
		File.open(file_path, "wb") do |f|
			f.write(content)
		end

		folder
	end

	def self.get_path(name,path)
		file_path="#{File.join(@@root_dir,path,name)}"
		file_path=@@default_dir unless File.exist?(file_path)

		return file_path
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