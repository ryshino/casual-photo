require 'rails_helper'

RSpec.describe "トップページ", type: :system do
  let(:user) { FactoryBot.create(:user) }
  before do
    visit root_path
  end

  describe "文字列とボタンが正常に表示されているか" do
    describe "画面の表示" do
      context "サブタイトル" do
        it "3つのサブタイトルが存在すること" do
          expect(page).to have_content "あなたが本当に 見せたかった１枚を"
          expect(page).to have_content "コメントをしてみよう！"
          expect(page).to have_content "気軽に投稿してみよう！"
        end
      end
    end
  end
end
