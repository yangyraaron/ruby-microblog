class AttachmentsController < ApplicationController	
  def show
  	 id=params[:id]

  	 attachment = Attachment.find_by_id(id)
  	 name="#{id}#{attachment.ext}"
  	 path=AttachmentFile.get_path(name,attachment.path)

  	 send_file(path,:filename=>name,:type=>attachment.mime)
  end
end
