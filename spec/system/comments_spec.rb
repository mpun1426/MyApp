require 'rails_helper'

RSpec.describe "Comments", type: :system do
  let(:user) { create(:user) }
  let(:spot) { create(:spot) }

  describe "スポット詳細ページのコメント機能" do
    context "ログイン済の場合" do
      before do
        visit new_user_session_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        click_button "ログイン"
        visit spot_path(spot)
      end

      it "コメント投稿フォームのリンクが存在すること" do
        expect(page).to have_content "コメントする"
      end

      it "コメントを投稿できること" do
        find("div.me-2 span.pointer", text: "コメントする").click
        fill_in 'comment[content]', with: "コメントします"
        click_button "投稿する"
        expect(page).to have_content "コメントします"
      end

      context "1件(3件以下)コメントを投稿した場合" do
        before do
          find("div.me-2 span.pointer", text: "コメントする").click
          fill_in 'comment[content]', with: "1件のテストコメント"
          click_button "投稿する"
        end

        it "コメントが1件表示されていること" do
          expect(page).to have_selector "div.col.border.rounded.mb-3.px-2", count: 1
        end

        it "コメント投稿者名が表示されていること" do
          expect(page).to have_content user.nickname + "さんのコメント"
        end

        it "コメント本文が表示されていること" do
          expect(page).to have_content "1件のテストコメント"
        end

        it "全てのコメントを見るリンクが存在しないこと" do
          expect(page).not_to have_link "全てのコメントを見る"
        end
      end

      context "4件(3件を超える)コメントを投稿した場合" do
        before do
          4.times do
            find("div.me-2 span.pointer", text: "コメントする").click
            fill_in 'comment[content]', with: "4件のテストコメント"
            click_button "投稿する"
          end
        end

        it "コメントが3件表示されていること" do
          expect(page).to have_selector "div.col.border.rounded.mb-3.px-2", count: 3
        end

        it "コメントが3件を超えて表示されていないこと" do
          expect(page).not_to have_selector "div.col.border.rounded.mb-3.px-2", count: 4
        end

        it "コメント投稿者名が表示されていること" do
          expect(page).to have_content user.nickname + "さんのコメント"
        end

        it "コメント本文が表示されていること" do
          expect(page).to have_content "4件のテストコメント"
        end

        it "全てのコメントを見るリンクが存在すること" do
          expect(page).to have_link "全てのコメントを見る"
        end

        it "全てのコメントを見るリンク押下で全てのコメントページにアクセスできること" do
          click_link "全てのコメントを見る"
          expect(current_path).to eq spot_comments_path(spot)
        end
      end
    end

    context "未ログインの場合" do
      it "コメント投稿フォームにアクセスできないこと" do
        visit spot_path(spot)
        expect(page).to have_content "コメントする場合はログインが必要です。"
      end

      context "コメントが3件以下の場合" do
        let!(:comments) { create_list(:comment, 3, user_id: user.id, spot_id: spot.id) }

        it "全てのコメントを見るリンクが存在しないこと" do
          visit spot_path(spot)
          expect(page).not_to have_link "全てのコメントを見る"
        end
      end

      context "コメントが3件を超える場合" do
        let!(:comments) { create_list(:comment, 4, user_id: user.id, spot_id: spot.id) }

        it "全てのコメントを見るリンクが存在すること" do
          visit spot_path(spot)
          expect(page).to have_link "全てのコメントを見る"
        end

        it "全てのコメントを見るリンク押下で全てのコメントページにアクセスできること" do
          visit spot_path(spot)
          click_link "全てのコメントを見る"
          expect(current_path).to eq spot_comments_path(spot)
        end
      end
    end
  end

  describe "全てのコメント一覧ページ" do
    let!(:comments) { create_list(:comment, 4, user_id: user.id, spot_id: spot.id) }

    before do
      visit spot_path(spot)
      click_link "全てのコメントを見る"
    end

    it "全てのコメントページにアクセスできること" do
      expect(current_path).to eq spot_comments_path(spot)
    end

    it "4件全てのコメントが表示されていること" do
      expect(page).to have_selector "div.col.border.rounded-3.mb-3.px-3.py-1", count: 4
    end
  end
end
