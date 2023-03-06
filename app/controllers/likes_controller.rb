class LikesController < ApplicationController
  def create
    like = current_user.likes.new(spot_id: params[:spot_id])
    like.save
    flash[:notice] = "いいねしました"
    redirect_back(fallback_location: root_path)
  end

  def destroy
    like = current_user.likes.find_by(spot_id: params[:spot_id])
    like.destroy
    flash[:notice] = "いいねを削除しました"
    redirect_back(fallback_location: root_path)
  end
end
