require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:user) { create(:user) }
  let(:spot) { create(:spot) }
  let(:comment) { create(:comment, user_id: user.id, spot_id: spot.id) }

  describe "GET コメント一覧ページ" do
    it "正常にアクセスできること" do
      get spot_comments_path(spot)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST コメント投稿" do
    before do
      sign_in user
    end

    context "有効なパラメーターの場合" do
      it "正常にコメントを投稿できること" do
        expect do
          post spot_comments_path(spot), params: { comment: { content: "コメント本文", user_id: user.id, spot_id: spot.id } }
        end.
          to change(Comment, :count).by(1)
      end

      it "コメントを投稿したらそのスポットにリダイレクトすること" do
        post spot_comments_path(spot), params: { comment: { content: "コメント本文", user_id: user.id, spot_id: spot.id } }
        expect(response).to have_http_status(302)
      end

      it '同じスポットに複数回コメントを投稿できること' do
        expect do
          2.times do
            post spot_comments_path(spot), params: { comment: { content: "コメント本文", user_id: user.id, spot_id: spot.id } }
          end
        end.
          to change(Comment, :count).by(2)
      end
    end

    context "無効なパラメーターの場合" do
      it "コメントを投稿できないこと" do
        expect do
          post spot_comments_path(spot), params: { comment: { content: "", user_id: user.id, spot_id: spot.id } }
        end.
          not_to change(Comment, :count)
      end

      it "バリデーションエラーとなり、コメントしようとしたスポットにリダイレクトすること" do
        post spot_comments_path(spot), params: { comment: { content: "", user_id: user.id, spot_id: spot.id } }
        expect(response).to have_http_status(302)
      end
    end
  end
end
