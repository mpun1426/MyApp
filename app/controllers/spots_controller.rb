class SpotsController < ApplicationController
  before_action :set_spot, only: [:show, :edit, :update, :destroy]

  def index
    @spots = Spot.with_attached_images
  end

  def show
  end

  def new
    @spot = Spot.new
  end

  def edit
  end

  def create
    @spot = Spot.new(spot_params)
    respond_to do |format|
      if @spot.save
        format.html { redirect_to spot_url(@spot), notice: "おすすめスポットの投稿が完了しました" }
        format.json { render :show, status: :created, location: @spot }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @spot.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @spot.update(spot_params)
        format.html { redirect_to spot_url(@spot), notice: "おすすめスポットの編集が完了しました" }
        format.json { render :show, status: :ok, location: @spot }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @spot.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @spot.destroy
    respond_to do |format|
      format.html { redirect_to spots_url, notice: "おすすめスポットの削除が完了しました" }
      format.json { head :no_content }
    end
  end

  def edit_select
    @myspots = Spot.with_attached_images.where(user_id: current_user.id) if current_user.present?
  end

  private

  def set_spot
    @spot = Spot.with_attached_images.includes(:user).find(params[:id])
  end

  def spot_params
    params.require(:spot).permit(:user_id, :name, :address, :feature, :describe, images: [])
  end
end
