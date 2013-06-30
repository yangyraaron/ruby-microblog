class FeedsController < ApplicationController


  # POST /feeds
  # POST /feeds.json
  def create
    @feed = Feed.new(params[:feed])
    @feed.creator_id=current_user.user_id

    respond_to do |format|
      if @feed.save
        User.update_counters(current_user.user_id,{:msg_count=>1})

        format.html { redirect_to home_url, notice: 'Feed was successfully created.' }
        format.json { render json: @feed, status: :created, location: @feed }
      else
        format.html { render action: "new" }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  #POST /feeds/:id/forward
  #POST /feeds/:id/forward.json
  def forward
    @feed = Feed.new(params[:feed])
    @feed.creator_id = current_user.user_id

    logger.info("origin feed id: #{@feed.origin_feed_id}")
    respond_to do |format|
      if @feed.save
        User.update_counters(current_user.user_id,{:msg_count=>1})
        Feed.update_counters(@feed.origin_feed_id,{:forward_count=>1})

        format.html {redirect_to home_url,notice: 'Feed was successfully forwarded'}
        format.json {render json: @feed.id, status: :created, location: @feed}
      else
        format.html {render action: "forward"}
        format.json {render json: @feed.errors, status: :unprocessable_entity}
      end
    end
  end

  #GET /feeds/:id/comments.json
  def comments
    id = params[:id]
    @comments = Comment.get_feed_comments(id)

    respond_to do |format|
      format.json {render :json=>@comments}
    end
  end

  #POST /feeds/:id/comment.json
  def comment
    @comment = Comment.new(params[:comment])
    @comment.creator_id = current_user.user_id

    respond_to do |format|
      if @comment.save
        Feed.update_counters(@comment.feed_id,{:comment_count=>1})
        format.json {render json: @comment.id}
        else
          format.json {render json: @comment.errors,status=>:unprocessable_entity}
        end
    end
  end
  
end
