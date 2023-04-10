require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:spot) { create(:spot) }
  let!(:comment) { create(:comment, user_id: user.id, spot_id: spot.id) }

  context "有効な値でコメントする場合" do
    it "commentが有効であること" do
      expect(comment).to be_valid
    end
  end

  context "無効な値でコメントする場合" do
    it "content(コメント本文)が空の場合、commentが無効であること" do
      comment.content = ""
      expect(comment).not_to be_valid
    end

    it "user_idが空の場合、commentが無効であること" do
      comment.user_id = ""
      expect(comment).not_to be_valid
    end

    it "spot_idが空の場合、commentが無効であること" do
      comment.spot_id = ""
      expect(comment).not_to be_valid
    end
  end

  context 'スポットを削除した場合' do
    it 'スポットのコメントも併せて削除されること' do
      expect { spot.destroy }.to change(Comment, :count).by(-1)
    end
  end

  context 'ユーザーを削除した場合' do
    it 'ユーザーのコメントも併せて削除されること' do
      expect { user.destroy }.to change(Comment, :count).by(-1)
    end
  end
end
