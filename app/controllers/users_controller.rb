class UsersController < ApplicationController
  include ApplicationHelper

  skip_before_filter :authorize,:only=>[:new,:create,:show]
  layout "content",:except=>[:new,:create]

  @@page_size=6;
  # GET /users
  # GET /users.json
  def index

    page_index=params["page_index"].present??params["page_index"].to_i : 1
    page={:size=>@@page_size,:index=>page_index}

    @page_users = User.search(current_user.user_id,params["filter"],page)
    @page_users[:total_page]= caculate_total_page(@page_users[:count],@@page_size)
    @page_users[:current_index]=page_index

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @page_users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.get_with_relation(params[:id],current_user.user_id)
    #@feeds = Feed.get_user_feeds(current_user.user_id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    @user.user_id=IdGenerator.generate_id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    portrait=params[:user][:portrait]

    @user.image_id=save_user_pic(portrait)

    @user.following_count=0;
    @user.msg_count=0;
    @user.fans_count=0;

    respond_to do |format|
      if @user.save
        signin(@user.account,@user.password)

        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    portrait=params[:user][:portrait]

    @user.image_id=save_user_pic(portrait)
    params[:user][:image_id]=@user.image_id

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def feeds
    user_id = params[:id]
    page_index=params["page_index"].present??params["page_index"].to_i : 1
    page={:size=>@@page_size,:index=>page_index}

    @page_feeds = Feed.get_user_feeds(user_id,page)
    @page_feeds[:total_page]= caculate_total_page(@page_feeds[:count],@@page_size)
    @page_feeds[:current_index]=page_index

    respond_to do |format|
      format.html { redirect_to user_url}

      str_json = @page_feeds.as_json(:except=>[:id,:origin_feed_id],:methods=>[:this_id,:origin_id,:origin_feed_json])
      format.json { render json: str_json}
    end
  end

  def refresh_feeds
    page_index=params["page_index"].present??params["page_index"].to_i : 1
    page={:size=>@@page_size,:index=>page_index}

    @page_feeds = Feed.get_feeds(current_user.user_id,page)
    @page_feeds[:total_page]= caculate_total_page(@page_feeds[:count],@@page_size)
    @page_feeds[:current_index]=page_index

    respond_to do |format|
      format.html { redirect_to home_url}

      str_json = @page_feeds.as_json(:except=>[:id,:origin_feed_id],:methods=>[:this_id,:origin_id,:origin_feed_json])
      format.json { render json:str_json }
    end
  end

  private
    def save_user_pic(portrait)
      if !portrait.nil?
        content=portrait.read

        extname=File.extname(portrait.original_filename)
        id=IdGenerator.generate_id

        folder=AttachmentFile.save("#{id}#{extname}",content)

        attachment=Attachment.new({:id=>id,
                                   :name=>portrait.original_filename,
                                   :path=>folder,
                                   :ext=>extname,
                                   :mime=>portrait.content_type})
        attachment.save

        id
      end
    end

end
