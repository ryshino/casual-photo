require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  describe "ログインページ" do
    let(:user) { FactoryBot.create(:user) }

    context "ページレイアウト" do
      before do
        visit login_path
      end

      it "【採用担当者様 専用ログインフォーム】の文字列が存在すること" do
        expect(page).to have_content "【採用担当者様 専用ログインフォーム】"
      end

      it "ナビバーにログインページへのリンクがあることを確認" do
        expect(page).to have_link 'ログイン', href: login_path
      end

      it "ログインフォームのラベルが正しく表示される" do
        expect(page).to have_content 'メールアドレス'
        expect(page).to have_content 'パスワード'
      end

      it "ログインボタンが表示される" do
        expect(page).to have_button 'ログイン'
      end

      it "ログインする前後でナビバーが正しく表示されること" do
        expect(page).to have_link 'Casual-Photo', href: root_path
        expect(page).to have_link '写真一覧', href: photos_path
        expect(page).to have_link 'ユーザー一覧', href: users_path
        expect(page).to have_link '新規登録', href: signup_path
        expect(page).to have_link 'ログイン', href: login_path

        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        click_button "専用ログイン"

        expect(page).to have_link 'Casual-Photo', href: root_path
        expect(page).to have_link '写真一覧', href: photos_path
        expect(page).to have_link 'ユーザー一覧', href: users_path
        expect(page).to have_link 'マイページ', href: user_path(user)
        expect(page).to have_link 'ログアウト', href: logout_path
      end
    end

    context "ログイン処理" do
      before do
        visit login_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        click_button "専用ログイン"
      end

      it "ログインをする" do
        expect(page).to have_content "ログインに成功しました"
      end
  
      it "ログインに失敗する" do
        visit login_path
        fill_in "メールアドレス", with: ""
        fill_in "パスワード", with: ""
        click_button "専用ログイン"
        expect(page).to have_content "メールアドレスもしくはパスワードの入力に誤りがあります"      
      end
    
      it "ログアウトする" do        
        click_link "ログアウト"
        expect(page).to have_content "ログアウトしました"
      end
    end
  end
end
