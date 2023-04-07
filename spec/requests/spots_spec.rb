require 'rails_helper'

RSpec.describe "/spots", type: :request do
  let(:user) { create(:user) }
  let(:spot) { create(:spot) }
  let(:current_user_created_spot) { create(:spot, user_id: user.id)}
  let(:spot_valid_params) { {spot: attributes_for(:spot, user_id: user.id)} }
  let(:spot_invalid_params) { {spot: attributes_for(:spot, name: "", address: "", user_id: user.id)} }
  let(:valid_attributes) { skip("Add a hash of attributes valid for your model") }
  let(:invalid_attributes) { skip("Add a hash of attributes invalid for your model") }

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
      it "アクセスできないこと" do
        get new_spot_path
        expect(response).not_to have_http_status(200)
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
        expect(response.body).to include('スポット投稿')
      end
    end
  end

  describe "PATCH スポット編集" do
    context "有効なパラメーターの場合" do
      let(:new_attributes) { skip("Add a hash of attributes valid for your model") }

      it "正常に編集を完了すること" do
        spot = Spot.create! valid_attributes
        patch spot_url(spot), params: { spot: new_attributes }
        spot.reload
        skip("Add assertions for updated state")
      end

      it "編集が完了したらそのスポットにリダイレクトすること" do
        spot = Spot.create! valid_attributes
        patch spot_url(spot), params: { spot: new_attributes }
        spot.reload
        expect(response).to redirect_to(spot_url(spot))
      end
    end

    context "無効なパラメーターの場合" do
      it "バリデーションエラーとなり、編集ページをレンダリングすること" do
        spot = Spot.create! valid_attributes
        patch spot_url(spot), params: { spot: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE スポット削除" do
    it "正常にスポットを削除できること" do
      spot = Spot.create! valid_attributes
      expect { delete spot_url(spot) }.to change(Spot, :count).by(-1)
    end

    it "スポット一覧ページにリダイレクトすること" do
      spot = Spot.create! valid_attributes
      delete spot_url(spot)
      expect(response).to redirect_to(spots_url)
    end
  end
end
