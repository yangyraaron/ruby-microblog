class ApplicationController < ActionController::Base
  before_filter :authorize
  protect_from_forgery

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
end
