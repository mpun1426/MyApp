require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }

  describe "GET ログイン画面(sessions new)" do
    context "未ログインの場合" do
      it "アクセスできること" do
        get new_user_session_path
        expect(response).to have_http_status(200)
        expect(response.body).to include "ログイン"
        expect(response.body).to include "初めてご利用の場合："
      end
    end

    context "ログイン済の場合" do
      it "トップページにリダイレクトすること" do
        sign_in user
        get new_user_session_path
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "GET ユーザーアカウント登録画面(registrations new)" do
    context "未ログインの場合" do
      it "アクセスできること" do
        get new_user_registration_path
        expect(response).to have_http_status(200)
        expect(response.body).to include "ユーザー登録"
        expect(response.body).to include "既にアカウントをお持ちの場合："
      end
    end

    context "ログイン済の場合" do
      it "トップページにリダイレクトすること" do
        sign_in user
        get new_user_session_path
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "GET ユーザーアカウント編集画面(registrations edit)" do
    context "ログイン済の場合" do
      it "アクセスできること" do
        sign_in user
        get edit_user_registration_path
        expect(response).to have_http_status(200)
        expect(response.body).to include "アカウント設定"
        expect(response.body).to include "アカウント編集"
      end
    end

    context "未ログインの場合" do
      it "ログインページにリダイレクトすること" do
        get edit_user_registration_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET マイページ" do
    context "ログイン済の場合" do
      before do
        sign_in user
      end

      it "マイページにアクセスできること" do
        get users_account_path
        expect(response).to have_http_status(200)
        expect(response.body).to include "マイページ"
      end

      it "マイページではユーザーアカウント情報を確認できること" do
        get users_account_path
        expect(response.body).to include "ニックネーム", user.nickname
        expect(response.body).to include "一言紹介", user.introduction
        expect(response.body).to include "メールアドレス", user.email
        expect(response.body).to include "パスワード", "表示されません"
        expect(response.body).not_to include user.password
      end
    end

    context "未ログインの場合" do
      it "未ログイン画面を表示すること" do
        get users_account_path
        expect(response).to have_http_status(200)
        expect(response.body).to include "この操作を行うにはログインが必要です"
      end
    end
  end

  describe "POST ログイン(sessions create)" do
    context "有効なパラメーターの場合" do
      let(:login_valid_params) do
        { user: { email: user.email, password: user.password } }
      end

      it "ログインしたらトップページにリダイレクトすること" do
        post user_session_path, params: login_valid_params
        expect(response).to redirect_to root_path
      end
    end

    context "無効なパラメーターの場合" do
      let(:login_invalid_params) do
        { user: { email: "hoge", password: "fuga" } }
      end

      it "バリデーションエラーとなり、ログインページをレンダリングすること" do
        post user_session_path, params: login_invalid_params
        expect(response).to have_http_status(200)
        expect(response.body).to include "メールアドレスまたはパスワードが違います。"
      end
    end
  end

  describe "DELETE ログアウト(sessions destroy)" do
    before do
      sign_in user
    end

    it "ログアウトしたらトップページにリダイレクトすること" do
      delete destroy_user_session_path
      expect(response).to redirect_to root_path
    end
  end

  describe "POST ユーザーアカウント登録(registrations create)" do
    context "有効なパラメーターの場合" do
      let(:signup_valid_params) do
        { user: {
          nickname: "アカウント登録",
          email: "sample@email.com",
          password: "password",
          password_confirmation: "password",
          introduction: "自己紹介",
        } }
      end

      it "正常にユーザーアカウントを登録できること" do
        expect do
          post user_registration_path, params: signup_valid_params
        end.
          to change(User, :count).by(1)
      end

      it "ユーザーアカウント登録が完了したらトップページにリダイレクトすること" do
        post user_registration_path, params: signup_valid_params
        expect(response).to redirect_to root_path
      end
    end

    context "無効なパラメーターの場合" do
      let(:signup_invalid_params) do
        { user: { nickname: "", email: "sample_mail_com", password: "hoge", password_confirmation: "fuga", introduction: "" } }
      end

      it "ユーザーアカウントを登録できないこと" do
        expect do
          post user_registration_path, params: signup_invalid_params
        end.
          not_to change(User, :count)
      end

      it "バリデーションエラーとなり、ユーザーアカウント登録ページをレンダリングすること" do
        post user_registration_path, params: signup_invalid_params
        expect(response).to have_http_status(200)
        expect(response.body).to include "ユーザー登録"
        expect(response.body).to include "エラーが", "項目あります"
      end
    end
  end

  describe "PATCH ユーザーアカウント編集(registrations update)" do
    before do
      sign_in user
    end

    context "有効なパラメーターの場合" do
      before do
        @patch_valid_nickname = "ニューネーム"
        @patch_valid_email = "new@sample.com"
        @patch_valid_introduction = "紹介追加"
        patch user_registration_path, params: {
          user: {
            nickname: @patch_valid_nickname,
            email: @patch_valid_email,
            introduction: @patch_valid_introduction,
            current_password: user.password,
          },
        }
      end

      it "正常にユーザーアカウント編集を完了していること" do
        user.reload
        expect(user.nickname).to eq @patch_valid_nickname
        expect(user.email).to eq @patch_valid_email
        expect(user.introduction).to eq @patch_valid_introduction
      end

      it "ユーザーアカウント編集が完了したらトップページにリダイレクトすること" do
        expect(response).to redirect_to root_path
      end
    end

    context "無効なパラメーターの場合" do
      before do
        @patch_invalid_nickname = ""
        @patch_invalid_email = ""
        patch user_registration_path, params: {
          user: {
            nickname: @patch_invalid_nickname,
            email: @patch_invalid_email,
            current_password: user.password,
          },
        }
      end

      it "ユーザーアカウントが無効なパラメーターに更新されていないこと" do
        user.reload
        expect(user.nickname).not_to eq @patch_invalid_nickname
        expect(user.email).not_to eq @patch_invalid_email
      end

      it "バリデーションエラーとなり、ユーザーアカウント編集ページをレンダリングすること" do
        expect(response).to have_http_status(200)
        expect(response.body).to include "アカウント編集", "エラーが", "項目あります"
      end
    end
  end

  describe "DELETE ユーザーアカウント削除(registrations destroy)" do
    before do
      sign_in user
    end

    it "正常にユーザーアカウントを削除できること" do
      expect { delete user_registration_path }.to change(User, :count).by(-1)
    end

    it "ユーザーアカウント削除後はトップページにリダイレクトすること" do
      delete user_registration_path
      expect(response).to redirect_to root_path
    end
  end

  describe "POST ゲストログイン(sessions guest_login)" do
    it "正常にゲストログインできること" do
      post users_guest_login_path
      expect(response).to redirect_to root_path
    end
  end

  describe "PATCH ゲストユーザーアカウント編集" do
    before do
      @guest = User.guest
      sign_in @guest
    end

    context "有効なパラメーターの場合でも、" do
      before do
        @patch_valid_nickname = "ニューネーム"
        @patch_valid_email = "new@sample.com"
        @patch_valid_introduction = "紹介追加"
        patch user_registration_path, params: {
          user: {
            nickname: @patch_valid_nickname,
            email: @patch_valid_email,
            introduction: @patch_valid_introduction,
            current_password: "password",
          },
        }
      end

      it "ゲストユーザーアカウント情報は変更されていないこと" do
        @guest.reload
        expect(@guest.nickname).not_to eq @patch_valid_nickname
        expect(@guest.email).not_to eq @patch_valid_email
        expect(@guest.introduction).not_to eq @patch_valid_introduction
      end

      it "トップページにリダイレクトし、ゲストユーザーは編集できない旨のメッセージを表示すること" do
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to include "ゲストユーザーの更新・削除はできません"
      end
    end
  end

  describe "DELETE ゲストユーザーアカウント削除" do
    before do
      sign_in User.guest
    end

    it "ゲストユーザーアカウントは削除できないこと" do
      expect { delete user_registration_path }.not_to change(User, :count)
    end

    it "トップページにリダイレクトし、ゲストユーザーは削除できない旨のメッセージを表示すること" do
      delete user_registration_path
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to include "ゲストユーザーの更新・削除はできません"
    end
  end
end
