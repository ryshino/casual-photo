class FavoritesController < ApplicationController

  before_action :photo_params
  def create
    @favorite = current_user.favorites.create(photo_id: @photo.id)
  end
  
  def destroy
    @favorite = current_user.favorites.find_by(photo_id: @photo.id)
    @favorite.destroy
  end

  private
  def photo_params 
    @photo = Photo.find(params[:photo_id])
  end

end