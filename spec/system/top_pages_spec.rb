require 'rails_helper'

RSpec.describe "Top_pages", type: :system do
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
          expect(page).to have_content "公開範囲を設定できます！"
        end
      end

      context "ボタンの表示" do
        it "ログインしている場合" do
          visit login_path
          fill_in "メールアドレス", with: user.email
          fill_in "パスワード", with: user.password
          click_button "専用ログイン"

          visit root_path
          expect(page).to have_button("さあはじめよう！")
        end

        it "ログインしていない場合" do
          expect(page).to have_button("新規登録")
          expect(page).to have_button("ログイン")
        end
      end 
    end
  end
end
