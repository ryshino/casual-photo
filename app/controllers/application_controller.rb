class ApplicationController < ActionController::Base
  
  include SessionsHelper
  
  private
  
  def require_user_logged_in
    unless logged_in?
      flash[:notice] = "ログインが必要です"
      redirect_to login_url
    end
  end
end