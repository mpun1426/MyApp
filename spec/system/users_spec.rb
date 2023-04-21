require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }

  describe "ユーザー新規登録ページ" do
    before do
      visit new_user_registration_path
    end

    context "有効な値でユーザー登録する場合" do
      before do
        fill_in "ニックネーム", with: "新規ユーザー"
        fill_in "メールアドレス", with: "sample@email.com"
        fill_in "パスワード（6字以上）", with: "password"
        fill_in "パスワード（確認用）", with: "password"
        fill_in "一言紹介", with: "よろしく"
      end

      it "ユーザー登録を押下すると、登録完了してユーザーのレコードが1件増加すること" do
        expect { click_button "ユーザーを登録する" }.to change(User, :count).by(1)
      end

      it "ユーザー登録が完了したの旨のフラッシュメッセージを表示すること" do
        click_button "ユーザーを登録する"
        expect(current_path).to eq root_path
        expect(page).to have_content "ユーザー登録が完了しました"
      end
    end

    context "無効な値でユーザー登録しようとする場合" do
      before do
        fill_in "ニックネーム", with: "" # NG項目
        fill_in "メールアドレス", with: "invalid" # NG項目
        fill_in "パスワード（6字以上）", with: "x" # NG項目
        fill_in "パスワード（確認用）", with: "y" # NG項目
        fill_in "一言紹介", with: "" # OK項目
      end

      it "ユーザー登録を押下しても登録できず、ユーザーのレコード件数に変化なきこと" do
        expect { click_button "ユーザーを登録する" }.not_to change(User, :count)
      end

      it "エラーメッセージ（エラー件数）を表示すること" do
        click_button "ユーザーを登録する"
        expect(page).to have_content "エラーが4項目あります" # NG項目が4項目の為
      end
    end

    context "ゲストログインボタンを押下した場合" do
      before do
        click_link "ゲストログイン"
      end

      it "ゲストユーザーとしてログインし、トップページにリダイレクトすること" do
        expect(current_path).to eq root_path
        expect(page).to have_content "ゲストユーザー さん"
      end

      it "ゲストユーザーとしてログインした旨のメッセージを表示すること" do
        expect(page).to have_content "ゲストユーザーとしてログインしました"
      end
    end

    context "ログインリンクを押下した場合" do
      it "ログインページに遷移すること" do
        find("div.col-md-9 a.normallink").click
        expect(current_path).to eq new_user_session_path
      end
    end
  end

  describe "ログインページ" do
    before do
      visit new_user_session_path
    end

    context "有効な値でログインする場合" do
      before do
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        click_button "ログイン"
      end

      it "当該ユーザーとしてログインし、トップページにリダイレクトすること" do
        expect(page).to have_content user.nickname + " さん"
        expect(current_path).to eq root_path
      end

      it "ログインしたの旨のフラッシュメッセージを表示すること" do
        expect(page).to have_content "ログインしました"
      end
    end

    context "無効な値でユーザー登録しようとする場合" do
      before do
        fill_in "メールアドレス", with: "invalid_mail"
        fill_in "パスワード", with: "invalid_pw"
        click_button "ログイン"
      end

      it "再度ログインページを表示していること" do
        expect(current_path).to eq new_user_session_path
      end

      it "エラーメッセージを表示すること" do
        expect(page).to have_content "メールアドレスまたはパスワードが違います。"
      end
    end

    context "ゲストログインボタンを押下した場合" do
      before do
        click_link "ゲストログイン"
      end

      it "ゲストユーザーとしてログインし、トップページにリダイレクトすること" do
        expect(current_path).to eq root_path
        expect(page).to have_content "ゲストユーザー さん"
      end

      it "ゲストユーザーとしてログインした旨のメッセージを表示すること" do
        expect(page).to have_content "ゲストユーザーとしてログインしました"
      end
    end

    context "アカウント登録リンクを押下した場合" do
      it "アカウント登録ページに遷移すること" do
        click_link "アカウント登録"
        expect(current_path).to eq new_user_registration_path
      end
    end
  end

  describe "ログアウト" do
    context "一般ユーザーがログアウトする場合" do
      before do
        visit new_user_session_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        click_button "ログイン"
        click_link "ログアウト", match: :first
      end

      it "正常にログアウトできること" do
        expect(page).not_to have_content user.nickname + " さん"
        expect(current_path).to eq root_path
      end

      it "ログアウトしたの旨のフラッシュメッセージを表示すること" do
        expect(page).to have_content "ログアウトしました"
      end
    end

    context "ゲストユーザーがログアウトする場合" do
      before do
        visit new_user_session_path
        click_link "ゲストログイン"
        click_link "ログアウト", match: :first
      end

      it "正常にログアウトできること" do
        expect(page).not_to have_content "ゲストユーザー さん"
        expect(current_path).to eq root_path
      end

      it "ログアウトしたの旨のフラッシュメッセージを表示すること" do
        expect(page).to have_content "ログアウトしました"
      end
    end
  end

  describe "マイページ" do
    before do
      visit new_user_session_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログイン"
      visit users_account_path
    end

    it "ニックネームが表示されていること" do
      expect(page).to have_content user.nickname
    end

    it "一言紹介が表示されていること" do
      expect(page).to have_content user.introduction
    end

    it "メールアドレスが表示されていること" do
      expect(page).to have_content user.email
    end

    it "パスワードは表示されていないこと" do
      expect(page).not_to have_content user.password
      expect(page).not_to have_content user.password_confirmation
      expect(page).not_to have_content user.encrypted_password
      expect(page).to have_selector "table.mypagetable th", text: "パスワード"
      expect(page).to have_selector "table.mypagetable td", text: "表示されません"
    end
  end

  describe "アカウント設定ページ" do
    context "一般ユーザーの場合" do
      before do
        visit new_user_session_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        click_button "ログイン"
        visit edit_user_registration_path
      end

      context "有効な値の場合" do
        before do
          fill_in "ニックネーム", with: "変更ユーザー"
          fill_in "メールアドレス", with: "new_sample@email.com"
          fill_in "一言紹介", with: "おねがいします"
          fill_in 'user[current_password]', with: user.password
          click_button "アカウント情報を更新する"
        end

        it "正常にアカウントを変更できること" do
          expect(current_path).to eq root_path
          expect(page).to have_content "変更ユーザー さん"
        end

        it "アカウント情報を更新した旨のフラッシュメッセージを表示すること" do
          expect(page).to have_content "アカウント情報の更新が完了しました"
        end
      end

      context "無効な値の場合" do
        before do
          fill_in "ニックネーム", with: "無効な変更のユーザー" # OK項目
          fill_in "メールアドレス", with: "" # NG項目
          fill_in "一言紹介", with: "" # OK項目
          fill_in 'user[current_password]', with: "" # NG項目
          click_button "アカウント情報を更新する"
        end

        it "メッセージ（エラー件数）を表示すること" do
          expect(page).to have_content "エラーが2項目あります" # NG項目が2項目のため
        end

        it "アカウント情報を更新できていないこと" do
          expect(page).not_to have_content "無効な変更のユーザー"
          expect(page).to have_content user.nickname
        end
      end

      context "ユーザーアカウントを削除する場合" do
        before do
          click_button "アカウントを削除する"
        end

        it "正常にユーザーアカウントが削除されること" do
          expect { find("div.modal-footer a").click }.to change(User, :count).by(-1)
        end

        it "削除後はトップページにリダイレクトし、ログアウト状態であること" do
          find("div.modal-footer a").click
          expect(current_path).to eq root_path
          expect(page).not_to have_content user.nickname
        end
      end
    end

    context "ゲストユーザーの場合" do
      before do
        visit new_user_session_path
        click_link "ゲストログイン"
        visit edit_user_registration_path
      end

      context "有効な値で変更しようとする場合でも" do
        before do
          fill_in "ニックネーム", with: "セカンドゲスト"
          fill_in "メールアドレス", with: "new_guest@email.com"
          fill_in "一言紹介", with: "新しいゲストです"
          fill_in 'user[current_password]', with: User.guest.password
          click_button "アカウント情報を更新する"
        end

        it "トップページにリダイレクトし、ゲストユーザーは編集できない旨のメッセージを表示すること" do
          expect(current_path).to eq root_path
          expect(page).to have_content "ゲストユーザーの更新・削除はできません"
        end

        it "アカウント情報を更新できていないこと" do
          expect(page).not_to have_content "セカンドゲスト さん"
          expect(page).to have_content "ゲストユーザー さん"
        end
      end

      context "ゲストユーザーアカウントを削除しようとする場合" do
        before do
          click_button "アカウントを削除する"
        end

        it "ゲストユーザーアカウントは削除されないこと" do
          expect { find("div.modal-footer a").click }.not_to change(User, :count)
        end

        it "トップページにリダイレクトし、ゲストユーザーは削除できない旨のメッセージを表示すること" do
          find("div.modal-footer a").click
          expect(current_path).to eq root_path
          expect(page).to have_content "ゲストユーザーの更新・削除はできません"
        end

        it "依然ゲストユーザーにてログイン状態であること" do
          find("div.modal-footer a").click
          expect(page).to have_content "ゲストユーザー さん"
        end
      end
    end
  end
end
