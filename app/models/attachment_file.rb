require 'date'

class AttachmentFile
  @@root=Rails.root.join("attachments")

  def self.save(name,content)
    folder = check_dir

    file_path = "#{Rails.root.join(@@root,folder,name)}"
    File.open(file_path, "w")do |f|
      content.each do |b|
        str_b = [b].pack("C")
        f<<str_b
      end
    end

    folder
  end

  def self.get(name,path)
    content=[]

    file_path="#{Rails.root.join(@@root,path,name)}"
    File.open(file_path, "r") do |f|
      f.each_byte do |b|
        content<<b
      end
    end

    content
  end

  protected
    def self.check_dir
      if !Dir.exist?(@@root)
        Dir.mkdir(@@root)
      end

      child_folder=Date.today.to_s
      folder = File.join(@@root,child_folder)

      if !Dir.exist?(folder)
        Dir.mkdir(folder)
      end

      child_folder
    end
end
