require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let(:user) { create(:user) }
  let(:spot) { create(:spot) }

  before do
    sign_in user
  end

  describe "create Ajaxでいいね！する" do
    it "Ajaxでいいね！できること" do
      expect do
        post spot_likes_path(spot), params: { like: { user_id: user.id, spot_id: spot.id } }, xhr: true
      end.
        to change(Like, :count).by(1)
    end
  end

  describe "destroy Ajaxでいいね！解除" do
    before do
      post spot_likes_path(spot), params: { like: { user_id: user.id, spot_id: spot.id } }, xhr: true
    end

    it "Ajaxでいいね！を解除できること" do
      expect { delete spot_likes_path(spot), xhr: true }.to change(Like, :count).by(-1)
    end
  end
end
