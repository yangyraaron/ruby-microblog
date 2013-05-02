class FollowsController < ApplicationController
  # GET /follows
  # GET /follows.json
  def index
    @follows = Follow.all

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
        format.html { redirect_to user_url(@follow.following_id), notice: 'Follow was successfully created.' }
        format.json { render json: @follow, status: :created, location: @follow }
      else
        format.html { render action: "new" }
        format.json { render json: @follow.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /follows/1
  # DELETE /follows/1.json
  def destroy
    @follow = Follow.find(params[:id])
    @follow.destroy

    respond_to do |format|
      format.html { redirect_to follows_url }
      format.json { head :no_content }
    end
  end
end
