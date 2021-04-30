class ApplicationController < ActionController::Base
  
  include SessionsHelper
  
  private
  
  def require_user_logged_in
    unless logged_in?
      flash[:notice] = "ユーザ登録が必要です"
      redirect_to login_url
    end
  end
end