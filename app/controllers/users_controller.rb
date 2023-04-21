class UsersController < ApplicationController
  def likes
    if current_user.present?
      likes = Like.where(user_id: current_user.id).pluck(:spot_id)
      @like_list = Spot.with_attached_images.find(likes)
    end
  end
end
