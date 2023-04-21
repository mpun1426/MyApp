class LikesController < ApplicationController
  def create
    @spot = Spot.find(params[:spot_id])
    like = current_user.likes.new(spot_id: params[:spot_id])
    like.save
  end

  def destroy
    @spot = Spot.find(params[:spot_id])
    like = current_user.likes.find_by(spot_id: params[:spot_id])
    like.destroy
  end
end
