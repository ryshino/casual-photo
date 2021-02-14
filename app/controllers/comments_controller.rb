class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.new(comment_params)

    if @comment.save
      flash[:success] = "コメントを追加しました！"
    else
      flash[:danger] = "コメントの投稿ができませんでした"
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @photo = Photo.find(params[:photo_id])
    @comment = current_user.comments.find_by(photo_id: @photo.id)
    @comment.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def comment_params
    params.require(:comment).permit(:comment).merge(photo_id: params[:photo_id])
  end
end
