require 'rails_helper'

RSpec.describe "Tops", type: :request do
  describe "GET /root" do
    it "トップページにアクセスできること" do
      get root_path
      expect(response).to have_http_status(200)
      expect(response.body).to include "ItteMiyoへようこそ"
    end
  end

  describe "GET /term" do
    it "利用規約ページにアクセスできること" do
      get term_path
      expect(response).to have_http_status(200)
      expect(response.body).to include "この利用規約（以下，「本規約」といいます。）"
    end
  end

  describe "GET /privacy" do
    it "プライバシーポリシーページにアクセスできること" do
      get privacy_path
      expect(response).to have_http_status(200)
      expect(response.body).to include "プライバシーポリシー（以下，「本ポリシー」といいます。）"
    end
  end
end
