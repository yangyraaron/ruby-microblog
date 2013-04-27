class ApplicationController < ActionController::Base
  before_filter :authorize
  protect_from_forgery

  protected

  def authorize
    current_user_id = session[:user_id]

    logger.info("current user id : #{current_user_id}")

    if(!current_user_id)
      redirect_to signin_url
    else
      unless User.find_by_user_id(current_user_id)
        redirect_to signin_url
      end
    end
    
  end

  def signin(account,password)
    if user = User.authenticate(account,password)
      session[:user_id]=user
      user
    end
  end
end
