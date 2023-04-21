require 'rails_helper'

RSpec.describe Spot, type: :model do
  let(:user) { create(:user) }
  let!(:spot) { create(:spot, user_id: user.id) }

  context "有効な値でスポットを投稿する場合" do
    it "spotが有効であること" do
      expect(spot).to be_valid
    end

    it "name(スポット名)が1文字以上の場合、spotが有効であること" do
      spot.name = "n"
      expect(spot).to be_valid
    end

    it "name(スポット名)が25文字以下の場合、spotが有効であること" do
      spot.name = "n" * 25
      expect(spot).to be_valid
    end

    it "address(所在地)が1文字以上の場合、spotが有効であること" do
      spot.address = "n"
      expect(spot).to be_valid
    end

    it "address(所在地)が30文字以下の場合、spotが有効であること" do
      spot.address = "n" * 30
      expect(spot).to be_valid
    end

    it "images(画像)がファイルサイズ2MB以内の画像ファイルの場合、spotが有効であること" do
      spot.images = [Rack::Test::UploadedFile.new('spec/fixtures/images/1MB.jpeg', 'image/jpeg')]
      expect(spot).to be_valid
    end
  end

  context "無効な値でスポットを投稿する場合" do
    it "name(スポット名)が1文字未満の場合、spotが無効であること" do
      spot.name = ""
      expect(spot).not_to be_valid
    end

    it "name(スポット名)が25文字を超える場合、spotが無効であること" do
      spot.name = "n" * 26
      expect(spot).not_to be_valid
    end

    it "address(所在地)が1文字未満の場合、spotが無効であること" do
      spot.address = ""
      expect(spot).not_to be_valid
    end

    it "address(所在地)が30文字を超える場合、spotが無効であること" do
      spot.address = "n" * 31
      expect(spot).not_to be_valid
    end

    it "images(画像)のファイル形式が jpeg、jpg、gif、png 以外の場合、spotが無効であること" do
      spot.images = [Rack::Test::UploadedFile.new('spec/fixtures/other_files/sample.txt', 'text/plain')]
      expect(spot).not_to be_valid
      expect(spot.errors[:images]).to include "の対応ファイルは jpeg、jpg、gif、png です"
    end

    it "images(画像)のファイルサイズが2MBを超える場合、spotが無効であること" do
      spot.images = [Rack::Test::UploadedFile.new('spec/fixtures/images/3MB.jpeg', 'image/jpeg')]
      expect(spot).not_to be_valid
      expect(spot.errors[:images]).to include "ファイルのサイズは1枚につき2MBまでです"
    end
  end

  context "ユーザーを削除した場合" do
    it "ユーザーの投稿したスポットも併せて削除されること" do
      expect { user.destroy }.to change(Spot, :count).by(-1)
    end
  end
end
