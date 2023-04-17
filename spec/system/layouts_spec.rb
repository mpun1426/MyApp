require 'rails_helper'

RSpec.describe "Layouts", type: :system do
  let(:user) { create(:user) }
  let!(:spot1) { create(:spot, name: "スポットその1", address: "東京") }
  let!(:spot2) { create(:spot, name: "スポットその2", address: "大阪") }
  let(:own_spot) { create(:spot, user_id: user.id) }

  describe "ヘッダー" do
    describe "ロゴバナー" do
      it "ロゴバナーをクリックするとトップページに遷移すること" do
        visit spots_path
        click_link 'banner'
        expect(current_path).to eq root_path
      end
    end

    describe "フリーワード検索" do
      before do
        visit root_path
        fill_in 'q[name_or_address_or_feature_or_describe_cont]', with: spot1.name
        click_button "検索"
      end

      it "ワード検索したスポットが表示されていること" do
        expect(page).to have_content spot1.name
      end

      it "ワード検索していないスポットは表示されていないこと" do
        expect(page).not_to have_content spot2.name
      end
    end

    describe "ユーザーメニュー" do
      context "未ログインの場合" do
        before do
          visit root_path
        end

        it "「ログイン」を押下で正常にアクセスできること" do
          find("div.dropdown a", text: "ログイン").click
          expect(current_path).to eq new_user_session_path
        end

        it "「ユーザー登録」を押下で正常にアクセスできること" do
          find("div.dropdown a", text: "ユーザー登録").click
          expect(current_path).to eq new_user_registration_path
        end

        it "「スポット一覧を見てみる」を押下で正常にアクセスできること" do
          find("div.dropdown a", text: "スポット一覧を見てみる").click
          expect(current_path).to eq spots_path
        end
      end

      context "ログイン済の場合" do
        before do
          visit new_user_session_path
          click_link "ゲストログイン"
        end

        it "「おすすめスポット一覧」を押下で正常にアクセスできること" do
          find("div.dropdown a", text: "おすすめスポット一覧").click
          expect(current_path).to eq spots_path
        end

        it "「いいね！したスポット一覧」を押下で正常にアクセスできること" do
          find("div.dropdown a", text: "いいね！したスポット一覧").click
          expect(current_path).to eq users_likes_path
        end

        it "「おすすめスポット新規投稿」を押下で正常にアクセスできること" do
          find("div.dropdown a", text: "おすすめスポット新規投稿").click
          expect(current_path).to eq new_spot_path
        end

        it "「投稿したスポットの編集」を押下で正常にアクセスできること" do
          find("div.dropdown a", text: "投稿したスポットの編集").click
          expect(current_path).to eq spot_edit_select_path
        end

        it "「マイページ」を押下で正常にアクセスできること" do
          find("div.dropdown a", text: "マイページ").click
          expect(current_path).to eq users_account_path
        end

        it "「アカウント設定」を押下で正常にアクセスできること" do
          find("div.dropdown a", text: "アカウント設定").click
          expect(current_path).to eq edit_user_registration_path
        end
      end
    end
  end

  describe "スポットメニュー" do
    before do
      visit root_path
    end

    it "所在地がクリックした地名であるスポットを表示すること" do
      find("a.spotmenu-link", text: "東京").click
      expect(page).to have_content spot1.name # 所在地が東京のスポット
    end

    it "所在地がクリックした地名でないスポットは表示しないこと" do
      expect(page).not_to have_content spot2.name # 所在地が大阪のスポット
    end
  end

  describe "メインコンテンツ" do
    describe "トップページ" do
      before do
        visit root_path
      end

      it "メイン見出しが表示されていること" do
        expect(page).to have_content "ItteMiyoへようこそ"
      end

      it "サブ見出し1が表示されていること" do
        expect(page).to have_content "行ってみよう"
        expect(page).to have_content "おすすめスポットに行ってみよう！"
        expect(page).to have_content "行ってみぃよ"
        expect(page).to have_content "おすすめするから行ってごらん！"
      end

      it "サブ見出し2が表示されていること" do
        expect(page).to have_content "誰もが知る有名スポットから知る人ぞ知るコアなスポットまで"
        expect(page).to have_content "おすすめ観光スポットを共有しあおう！そして行ってみよう！"
      end

      it "「スポット一覧を見てみる」を押下でスポット一覧ページにアクセスできること" do
        find("a.topspotbutton", text: "スポット一覧を見てみる").click
        expect(current_path).to eq spots_path
      end
    end
  end

  describe "モバイルメニュー" do
    it "「トップページ」のロゴリンク押下でトップページに遷移すること" do
      visit spots_path
      find("div.col a", text: "トップページ").click
      expect(current_path).to eq root_path
    end

    context "未ログインの場合" do
      before do
        visit root_path
      end

      it "「スポット一覧へ」を押下で正常にアクセスできること" do
        find("div.dropup a", text: "スポット一覧へ").click
        expect(current_path).to eq spots_path
      end

      it "「ログイン」を押下で正常にアクセスできること" do
        find("div.dropup a", text: "ログイン").click
        expect(current_path).to eq new_user_session_path
      end

      it "「ユーザー登録」を押下で正常にアクセスできること" do
        find("div.dropup a", text: "ユーザー登録").click
        expect(current_path).to eq new_user_registration_path
      end
    end

    context "ログイン済の場合" do
      before do
        visit new_user_session_path
        click_link "ゲストログイン"
      end

      it "「スポットを編集」を押下で正常にアクセスできること" do
        find("div.dropup a", text: "スポットを編集").click
        expect(current_path).to eq spot_edit_select_path
      end

      it "「スポットを投稿」を押下で正常にアクセスできること" do
        find("div.dropup a", text: "スポットを投稿").click
        expect(current_path).to eq new_spot_path
      end

      it "「いいね！一覧へ」を押下で正常にアクセスできること" do
        find("div.dropup a", text: "いいね！一覧へ").click
        expect(current_path).to eq users_likes_path
      end

      it "「スポット一覧へ」を押下で正常にアクセスできること" do
        find("div.dropup a", text: "スポット一覧へ").click
        expect(current_path).to eq spots_path
      end

      it "「アカウント設定」を押下で正常にアクセスできること" do
        find("div.dropup a", text: "アカウント設定").click
        expect(current_path).to eq edit_user_registration_path
      end

      it "「マイページ」を押下で正常にアクセスできること" do
        find("div.dropup a", text: "マイページ").click
        expect(current_path).to eq users_account_path
      end
    end
  end

  describe "フッター" do
    context "利用規約をクリック" do
      before do
        visit root_path
        click_link "利用規約"
      end

      it "利用規約ページにアクセスできること" do
        expect(current_path).to eq term_path
      end

      it "利用規約を表示していること" do
        expect(page).to have_content "この利用規約（以下，「本規約」といいます。）は，"
      end
    end

    context "プライバシーポリシーをクリック" do
      before do
        visit root_path
        click_link "プライバシーポリシー"
      end

      it "プライバシーポリシーページにアクセスできること" do
        expect(current_path).to eq privacy_path
      end

      it "プライバシーポリシーを表示していること" do
        expect(page).to have_content "以下のとおりプライバシーポリシー（以下，「本ポリシー」といいます。）を定めます。"
      end
    end
  end
end
