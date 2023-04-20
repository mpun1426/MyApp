require 'rails_helper'

RSpec.describe "Likes", type: :system do
  let(:user) { create(:user) }
  let!(:liked_spot) { create(:spot, name: "いいねしたスポット") }
  let!(:other_spot) { create(:spot, name: "他のスポット") }
  let!(:like) { create(:like, user_id: user.id, spot_id: liked_spot.id) }

  describe "いいね！したスポット一覧" do
    context "ログイン済の場合" do
      before do
        visit new_user_session_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        click_button "ログイン"
        visit users_likes_path
      end

      it "いいね！したスポットが表示されていること" do
        expect(page).to have_content liked_spot.name
      end

      it "いいね！していないスポットは表示されていないこと" do
        expect(page).not_to have_content other_spot.name
      end
    end

    context "未ログインの場合" do
      it "未ログインページが表示されていること" do
        visit users_likes_path
        expect(page).to have_content "この操作を行うにはログインが必要です"
      end
    end
  end
end
