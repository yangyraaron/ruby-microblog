class FollowsController < ApplicationController
  layout "content"

  # GET /follows
  # GET /follows.json
  def index
    user_id = params[:user_id]
    user_id = current_user.user_id unless user_id.present?
      
    @follows = User.get_following(current_user.user_id)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @follows }
    end
  end



  # POST /follows
  # POST /follows.json
  def create
    @follow = Follow.new(params[:follow])
    @follow.id = IdGenerator.generate_id
    @follow.user_id=current_user.user_id

    logger.info("follow the user #{@follow.inspect}")

    respond_to do |format|
      if @follow.follow
        #reload the current user
        current_user.reload

        format.html { redirect_to user_url(@follow.following_id), notice: 'Follow was successfully created.' }
        format.json { render json: @follow, status: :created, location: @follow }
      else
        format.html { render action: "index" }
        format.json { render json: @follow.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /follows/1
  # DELETE /follows/1.json
  def destroy
    @follow = Follow.find_by_following_id(params[:id])
    @follow.unfollow

    current_user.reload

    respond_to do |format|
      #reload the user's profile
      format.html { redirect_to user_url(@follow.following_id) }
      format.json { head :no_content }
    end
  end
end
