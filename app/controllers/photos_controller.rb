class PhotosController < ApplicationController
  before_action :require_user_logged_in, except: [:index]
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def index
    @photos = Photo.includes(:user).open
    @photos_login = Photo.includes(:user)
  end

  def show
    @photo = Photo.find(params[:id])
    @comment = Comment.new
    @comments = @photo.comments.order(created_at: :asc)
  end

  def new
    @photo = Photo.new
  end
  
  def create
    @photo = current_user.photos.build(photo_params)
    if @photo.save
      flash[:notice] = '投稿に成功しました'
      redirect_to photo_path(@photo)
    else
      flash.now[:alert] = '投稿に失敗しました'
      render :new
    end
  end

  def edit
  end
  
  def update
    if @photo.update(photo_params)
      flash[:notice] = '更新に成功しました'
      redirect_to photo_path(@photo)
    else
      flash.now[:alert] = '更新に失敗しました'
      render :edit
    end
  end
  
  def destroy
    @photo.destroy
    flash[:notice] = '投稿を削除しました'
    redirect_back(fallback_location: root_path)
  end
  
  private
  
  def photo_params
    params.require(:photo).permit(:title, :body, :image, :status)
  end

  def correct_user
    @photo = current_user.photos.find_by(id: params[:id])
    unless @photo
      flash[:alert] = '不正なアクセスです'
      redirect_to root_url
    end
  end
end
