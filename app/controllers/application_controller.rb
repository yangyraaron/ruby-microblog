class ApplicationController < ActionController::Base
  before_filter :authorize
  protect_from_forgery

  rescue_from ActiveRecord::RecordNotFound,:with=>:record_not_found

  def current_user
    session[:user_id]
  end

  protected

    def authorize

      if(!current_user)
        redirect_to signin_url
      end

    end

    def signin(account,password)
      if user = User.authenticate(account,password)
        session[:user_id]=user
        user
      end
    end

    def record_not_found
      render :text=>"404 Not Found",:status=>404
    end
end
