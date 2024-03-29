class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:show, :edit, :update]
  before_action :set_user, only: [:edit, :update]
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "ユーザーを登録しました"
      redirect_to @user
    else
      flash.now[:alert] = "ユーザーの登録に失敗しました"
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "ユーザー情報を更新しました"
      redirect_to @user
    else
      flash.now[:alert] = "ユーザー情婦の更新に失敗しました"
      render :edit
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile, :image)
  end
  
  def set_user
    @user = User.find(params[:id])
    if @user != current_user
      flash[:alert] = "不正なアクセスです"
      redirect_to root_url
    end
  end
  
end