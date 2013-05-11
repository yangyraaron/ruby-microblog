class GroupsController < ApplicationController
  layout 'group'

  # GET /groups
  # GET /groups.json
  def index

    @follows = User.get_following(current_user.user_id)
    get_groups
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @group = Group.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.json
  def create
    logger.info('call the create ation')

    @group = Group.new(params[:group])
    @group.creator_id=current_user.user_id

    get_groups
    respond_to do |format|
      if @group.save
        format.html { redirect_to group_follows_url(@group.id) }
        format.json { render json: @group, status: :created, location: @group }
      else
        format.html { render action: "index" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    logger.info('call the update action')
    logger.info("the group id : #{params[:id]}")
    logger.info("the group info : #{params[:group]}")

    @group = Group.find(params[:id])

    logger.info("the group retrieved from database is : #{@group.inspect}'")

    get_groups
    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html {redirect_to group_follows_url(@group.id)}
        format.json { head :no_content }
      else
        format.html {render action:"index"}
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end

  def follows
    logger.info('call the follows action')

    group_id = params[:group_id]

    @group = Group.find_by_id(group_id)
    @follows = Group.get_follows(group_id)

    get_groups

    respond_to do |format|
      format.html {render action:"index"}
      format.json { render json: @follows }
    end
  end

  def add_follow_to_group
    follow_ids = params[:follow_ids]
    if(follow_ids.present?)
      @group = Group.find_by_id(params[:group_id])
      ids = @group.user_ids

      follow_ids.split(";").each do |follow_id|
        ids << follow_id
        @group.user_ids = ids
      end

    end

    respond_to do |format|
      format.html{redirect_to groups_url}
      format.json { render json: {:status=>"1"} }
    end
  end

  private

  def get_groups
    @groups = Group.get_groups(current_user.user_id)
  end
end
