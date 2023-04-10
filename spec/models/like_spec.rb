require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { create(:user) }
  let(:spot) { create(:spot) }
  let!(:like) { create(:like, user_id: user.id, spot_id: spot.id) }

  context "有効な値でいいね！する場合" do
    it "いいね！が有効であること" do
      expect(like).to be_valid
    end
  end

  context "無効な値でいいね！する場合" do
    it "user_idが空の場合、likeが無効であること" do
      like.user_id = ""
      expect(like).not_to be_valid
    end

    it "spot_idが空の場合、likeが無効であること" do
      like.spot_id = ""
      expect(like).not_to be_valid
    end
  end

  context 'ユーザーを削除した場合' do
    it 'ユーザーのいいね！も併せて削除されること' do
      expect { user.destroy }.to change(Like, :count).by(-1)
    end
  end
end
