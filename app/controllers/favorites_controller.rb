class FavoritesController < ApplicationController
  def create
    @favorite = current_user.favorites.create(photo_id: params[:photo_id])
    redirect_back(fallback_location: root_path)
  end
  
  def destroy
    @photo = Photo.find(params[:photo_id])
    @favorite = current_user.favorites.find_by(photo_id: @photo.id)
    @favorite.destroy
    redirect_back(fallback_location: root_path)
  end
end
