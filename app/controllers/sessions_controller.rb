class SessionsController < ApplicationController
	skip_before_filter :authorize
  def index
  	respond_to do |format|
  		logger.info("the format is #{format}")

  		format.html
  		format.json
  	end
  end

  def new
  end

  def create
  	if user = User.authenticate(params[:account],params[:password])
  		session[:user_id]=user.user_id
  		redirect_to user
  	else
  		redirect_to signin_url, :alert=>"Invalid user/password combination"
  	end
  end

  def destroy
  	session[:user_id]=nil
  	redirect_to home_url, :notice=>"Logged out"
  end
end
