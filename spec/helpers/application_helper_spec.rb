require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "ページタイトルの表示" do
    subject { full_title(page_title) }

    context "オブジェクトの引数に空文字が与えられた場合" do
      let(:page_title) { "" }

      it "ページタイトルの表示が「ベースタイトル」となること" do
        expect(subject).to eq "ItteMiyo"
      end
    end

    context "オブジェクトの引数にnilが与えられた場合" do
      let(:page_title) { nil }

      it "ページタイトルの表示が「ベースタイトル」となること" do
        expect(subject).to eq "ItteMiyo"
      end
    end

    context "オブジェクトの引数に空文字以外の値が与えられた場合" do
      let(:page_title) { "スポット" }

      it "ページタイトルの表示が「引数の値 - ベースタイトル」となること" do
        expect(subject).to eq "スポット - ItteMiyo"
      end
    end
  end
end
