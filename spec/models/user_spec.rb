require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }

  context "有効な値でユーザーを登録する場合" do
    it "userが有効であること" do
      expect(user).to be_valid
    end

    it "nickname(ニックネーム)が入力されている場合、userが有効であること" do
      user.nickname = "n"
      expect(user).to be_valid
    end

    it "email(メールアドレス)が正しい形式で入力されている場合、userが有効であること" do
      user.email = "sample@email.com"
      expect(user).to be_valid
    end

    it "password(パスワード)が6文字以上の場合、userが有効であること" do
      user.password = user.password_confirmation = "n" * 6
      expect(user).to be_valid
    end

    it "avatar(アバター)がファイルサイズ2MB以内の画像ファイルの場合、userが有効であること" do
      user.avatar = Rack::Test::UploadedFile.new('spec/fixtures/images/1MB.jpeg', 'image/jpeg')
      expect(user).to be_valid
    end
  end

  context "無効な値でユーザーを登録する場合" do
    it "nickname(ニックネーム)が未入力の場合、userが無効であること" do
      user.nickname = ""
      expect(user).not_to be_valid
    end

    it "email(メールアドレス)が未入力の場合、userが無効であること" do
      user.email = ""
      expect(user).not_to be_valid
    end

    it "email(メールアドレス)に@を含まない場合、userが無効であること" do
      user.email = "sample.com"
      expect(user).not_to be_valid
    end

    it "password(パスワード)が未入力の場合、userが無効であること" do
      user.password = user.password_confirmation = ""
      expect(user).not_to be_valid
    end

    it "password(パスワード)が6文字未満の場合、userが無効であること" do
      user.password = user.password_confirmation = "n" * 5
      expect(user).not_to be_valid
    end

    it "avatar(アバター)のファイル形式が jpeg、jpg、gif、png 以外の場合、userが無効であること" do
      user.avatar = Rack::Test::UploadedFile.new('spec/fixtures/other_files/sample.txt', 'text/plain')
      expect(user).not_to be_valid
      expect(user.errors[:avatar]).to include "の対応ファイルは jpeg、jpg、gif、png です"
    end

    it "avatar(アバター)のファイルサイズが2MBを超える場合、userが無効であること" do
      user.avatar = Rack::Test::UploadedFile.new('spec/fixtures/images/3MB.jpeg', 'image/jpeg')
      expect(user).not_to be_valid
      expect(user.errors[:avatar]).to include "ファイルのサイズは1枚につき2MBまでです"
    end
  end

  context "ユーザーを削除した場合" do
    before do
      @other_user_spot = create(:spot)
      @user_created_spot = create(:spot, user_id: user.id)
      @user_comment = create(:comment, user_id: user.id, spot_id: @other_user_spot.id)
      @user_like = create(:like, user_id: user.id, spot_id: @other_user_spot.id)
    end

    it "ユーザーが投稿したスポットも併せて削除されること" do
      expect { user.destroy }.to change(Spot, :count).by(-1)
    end

    it "ユーザーがスポットに投稿したコメントも併せて削除されること" do
      expect { user.destroy }.to change(Comment, :count).by(-1)
    end

    it "ユーザーがスポットにしたいいね！も併せて削除されること" do
      expect { user.destroy }.to change(Like, :count).by(-1)
    end
  end
end
