class FansController < ApplicationController
  layout "content"

  # GET /fans?user_id=?
  # GET /fans.json
  def index
    user_id = params[:user_id]
    user_id=current_user.user_id unless user_id.present?

    @fans = User.get_fans(user_id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fans }
    end
  end
end
