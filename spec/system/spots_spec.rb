require 'rails_helper'

RSpec.describe "Spots", type: :system do
  let(:user) { create(:user) }
  let!(:spots) { create_list(:spot, 2) }

  describe "おすすめスポット一覧ページ" do
    before do
      visit spots_path
    end

    it "投稿された数だけスポットが表示されていること" do
      expect(page).to have_selector "div.card.w-100.nonebutton", count: 2
    end

    it "それぞれのスポット名を表示していること" do
      expect(page).to have_content spots[0].name
      expect(page).to have_content spots[1].name
    end

    it "それぞれのスポットの所在地を表示していること" do
      expect(page).to have_content spots[0].address
      expect(page).to have_content spots[1].address
    end

    it "それぞれのスポットの説明文を表示していること" do
      expect(page).to have_content spots[0].describe
      expect(page).to have_content spots[1].describe
    end

    it "それぞれのスポットの特徴は表示していないこと" do
      expect(page).not_to have_content spots[0].feature
      expect(page).not_to have_content spots[1].feature
    end
  end

  describe "スポット新規投稿ページ" do
    context "ログイン済の場合" do
      before do
        visit new_user_session_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        click_button "ログイン"
        find("ul.dropdown-menu a", text: "おすすめスポット新規投稿").click
      end

      context "有効な値で投稿する場合" do
        before do
          fill_in 'spot[name]', with: "新規投稿のスポット名"
          fill_in 'spot[address]', with: "新規投稿の所在地"
          fill_in 'spot[feature]', with: "新規投稿の特徴"
          fill_in 'spot[describe]', with: "新規投稿の説明"
        end

        it "正常に投稿が完了すること" do
          expect { click_button "投稿を完了する" }.to change(Spot, :count).by(1)
        end

        it "投稿が完了した旨のメッセージが表示されること" do
          click_button "投稿を完了する"
          expect(page).to have_content "おすすめスポットの投稿が完了しました"
        end
      end

      context "無効な値で投稿しようとする場合" do
        before do
          fill_in 'spot[name]', with: ""
          fill_in 'spot[address]', with: ""
        end

        it "エラーメッセージが表示されること" do
          click_button "投稿を完了する"
          expect(page).to have_content "2 件のエラーが発生しました"
          expect(page).to have_content "スポット名は1文字以上で入力してください"
          expect(page).to have_content "所在地は1文字以上で入力してください"
        end

        it "投稿が完了していないこと" do
          expect { click_button "投稿を完了する" }.not_to change(Spot, :count)
        end
      end
    end

    context "未ログインの場合" do
      it "未ログインページが表示されていること" do
        visit new_spot_path
        expect(page).to have_content "この操作を行うにはログインが必要です"
      end
    end
  end

  describe "スポット編集ページ" do
    context "ログイン済の場合" do
      before do
        visit new_user_session_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        click_button "ログイン"
        find("ul.dropdown-menu a", text: "投稿したスポットの編集").click
      end

      it "編集するスポットを選択するページにアクセスできること" do
        expect(current_path).to eq spot_edit_select_path
      end

      context "自分の投稿が存在する場合" do
        let!(:user_spot) { create(:spot, name: "自分が投稿したスポット", user_id: user.id) }

        before do
          find("ul.dropdown-menu a", text: "投稿したスポットの編集").click
          find("div.row.mb-3.mx-2 a", text: user_spot.name).click
        end

        context "有効な値で編集完了する場合" do
          before do
            fill_in 'spot[name]', with: "スポット名編集"
            fill_in 'spot[address]', with: "所在地編集"
            fill_in 'spot[feature]', with: "特徴編集"
            fill_in 'spot[describe]', with: "説明編集"
          end

          it "正常に編集を完了すること" do
            click_button "投稿を完了する"
            expect(page).not_to have_content "自分が投稿したスポット"
            expect(page).to have_content "スポット名編集"
            expect(page).to have_content "所在地編集"
            expect(page).to have_content "特徴編集"
            expect(page).to have_content "説明編集"
          end

          it "編集が完了した旨のメッセージが表示されること" do
            click_button "投稿を完了する"
            expect(page).to have_content "おすすめスポットの編集が完了しました"
          end
        end

        context "無効な値で編集完了しようとする場合" do
          before do
            fill_in 'spot[name]', with: ""
            fill_in 'spot[address]', with: ""
            click_button "投稿を完了する"
          end

          it "エラーメッセージが表示されること" do
            expect(page).to have_content "2 件のエラーが発生しました"
            expect(page).to have_content "スポット名は1文字以上で入力してください"
            expect(page).to have_content "所在地は1文字以上で入力してください"
          end

          it "無効な値で編集が完了していないこと" do
            expect(user_spot.name).not_to eq ""
            expect(user_spot.name).to eq "自分が投稿したスポット"
          end
        end
      end

      context "自分の投稿が存在しない場合" do
        it "まだ自分が投稿してない旨の表示をすること" do
          expect(page).to have_content "まだスポットを投稿していません"
        end

        it "スポットを投稿するリンクを表示すること" do
          expect(page).to have_link "スポットを投稿する"
        end

        it "スポットを投稿するリンクを押下でスポット新規投稿ページに遷移すること" do
          click_link "スポットを投稿する"
          expect(current_path).to eq new_spot_path
        end
      end
    end

    context "未ログインの場合" do
      it "未ログインページが表示されていること" do
        visit spot_edit_select_path
        expect(page).to have_content "この操作を行うにはログインが必要です"
      end
    end
  end
end
