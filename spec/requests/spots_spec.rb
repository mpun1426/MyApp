require 'rails_helper'

RSpec.describe "Spots", type: :request do
  let(:user) { create(:user) }
  let(:spot) { create(:spot) }
  let!(:current_user_created_spot) { create(:spot, user_id: user.id) }
  let(:spot_valid_params) { { spot: attributes_for(:spot, user_id: user.id) } }
  let(:spot_invalid_params) { { spot: attributes_for(:spot, name: "", address: "", user_id: user.id) } }

  describe "GET スポット一覧ページ" do
    it "正常にアクセスできること" do
      get spots_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET スポット詳細ページ" do
    it "正常にアクセスできること" do
      get spot_path(spot)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET スポット新規投稿ページ" do
    context "ログイン済みの場合" do
      before do
        sign_in user
      end

      it "正常にアクセスできること" do
        get new_spot_path
        expect(response).to have_http_status(200)
      end
    end

    context "未ログインの場合" do
      it "未ログイン画面を表示すること" do
        get new_spot_path
        expect(response).to have_http_status(200)
        expect(response.body).to include "この操作を行うにはログインが必要です"
      end
    end
  end

  describe "GET スポット編集ページ" do
    context "ログイン済みの場合" do
      before do
        sign_in user
      end

      it "自分の投稿の場合、正常に編集画面にアクセスできること" do
        get edit_spot_path(current_user_created_spot)
        expect(response).to have_http_status(200)
        expect(response.body).to include "スポット編集"
      end

      it "自分の投稿でない場合、編集不可画面を表示すること" do
        get edit_spot_path(spot)
        expect(response).to have_http_status(200)
        expect(response.body).to include "自分の投稿以外は編集できません"
      end
    end

    context "未ログインの場合" do
      it "未ログイン画面を表示すること" do
        get edit_spot_path(spot)
        expect(response).to have_http_status(200)
        expect(response.body).to include "この操作を行うにはログインが必要です"
      end
    end
  end

  describe "POST スポット新規投稿" do
    before do
      sign_in user
    end

    context "有効なパラメーターの場合" do
      it "正常にスポットを新規投稿できること" do
        expect { post spots_path(spot_valid_params), params: spot_valid_params }.to change(Spot, :count).by(1)
      end

      it "スポットを投稿したらそのスポットにリダイレクトすること" do
        post spots_path, params: spot_valid_params
        expect(response).to have_http_status(302)
      end
    end

    context "無効なパラメーターの場合" do
      it "スポットを新規投稿できないこと" do
        expect { post spots_path(spot_invalid_params), params: spot_invalid_params }.not_to change(Spot, :count)
      end

      it "バリデーションエラーとなり、新規投稿ページをレンダリングすること" do
        post spots_path, params: spot_invalid_params
        expect(response).to have_http_status(422)
        expect(response.body).to include "スポット投稿"
      end
    end
  end

  describe "PATCH スポット編集" do
    before do
      sign_in user
    end

    context "有効なパラメーターの場合" do
      before do
        @patch_valid_name = "アフタースポット"
        @patch_valid_address = "市町村区"
        @patch_valid_feature = "特徴なし"
        @patch_valid_describe = "説明なし"
        patch spot_path(spot), params: {
          spot: {
            name: @patch_valid_name,
            address: @patch_valid_address,
            feature: @patch_valid_feature,
            describe: @patch_valid_describe,
            user_id: user.id,
          },
        }
      end

      it "正常に編集を完了していること" do
        spot.reload
        expect(spot.name).to eq @patch_valid_name
        expect(spot.address).to eq @patch_valid_address
        expect(spot.feature).to eq @patch_valid_feature
        expect(spot.describe).to eq @patch_valid_describe
      end

      it "編集が完了したらそのスポットにリダイレクトすること" do
        expect(response).to redirect_to(spot_path(spot))
      end
    end

    context "無効なパラメーターの場合" do
      before do
        @patch_invalid_name = ""
        @patch_invalid_address = ""
        patch spot_path(spot), params: {
          spot: {
            name: @patch_invalid_name,
            address: @patch_invalid_address,
            user_id: user.id,
          },
        }
      end

      it "バリデーションエラーとなること" do
        expect(response).to have_http_status(422)
      end

      it "スポットが無効なパラメーターに更新されていないこと" do
        spot.reload
        expect(spot.name).not_to eq @patch_invalid_name
        expect(spot.address).not_to eq @patch_invalid_address
      end

      it "編集ページをレンダリングすること" do
        expect(response.body).to include "スポット編集"
      end
    end
  end

  describe "DELETE スポット削除" do
    before do
      sign_in user
    end

    context "自分の投稿の場合" do
      it "正常にスポットを削除できること" do
        expect { delete spot_path(current_user_created_spot) }.to change(Spot, :count).by(-1)
      end

      it "スポット一覧ページにリダイレクトすること" do
        delete spot_path(current_user_created_spot)
        expect(response).to redirect_to(spots_path)
      end
    end

    context "自分の投稿でない場合" do
      it "スポットを削除できないこと" do
        expect { delete spot_path(spot) }.not_to change(Spot, :count)
      end

      it "スポット一覧ページにリダイレクトすること" do
        delete spot_path(spot)
        expect(response).to redirect_to(spots_path)
      end
    end
  end
end
