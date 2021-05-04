require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { FactoryBot.create(:user) }
  
  describe "ログインページ" do
    it "ログインをする" do
      visit login_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "専用ログイン"
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
      visit login_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "専用ログイン"
      
      click_link "ログアウト"
      expect(page).to have_content "ログアウトしました"
    end
  end


  describe "ユーザー登録ページ" do
    before do
      visit signup_path
    end

    it "新規登録する" do
      fill_in "ユーザー名", with: "new_user"
      fill_in "メールアドレス", with: "new_user@example.com"
      fill_in "パスワード", with: "1" * 6
      fill_in "確認用", with: "1" * 6
      click_button "Sign up!"
      expect(page). to have_content "ユーザーを登録しました"
    end

    it "新規登録に失敗する" do
      fill_in "ユーザー名", with: ""
      fill_in "メールアドレス", with: "new_user@example.com"
      fill_in "パスワード", with: "1" * 6
      fill_in "確認用", with: "2" * 6
      click_button "Sign up!"
      aggregate_failures do
        expect(page). to have_content "ユーザーの登録に失敗しました"
        expect(page). to have_content "ユーザー名を入力してください"
        expect(page). to have_content "パスワード(確認)とパスワードの入力が一致しません"
      end
    end
  end

  describe "ユーザー編集ページ" do
    it "ユーザー情報を編集する" do
      visit login_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "専用ログイン"

      click_link "編集"
      fill_in "ユーザー名", with: "テストユーザー"
      fill_in "メールアドレス", with: "edit@example.com"
      fill_in "プロフィール", with: "プロフィール"
      attach_file "プロフィール画像", "spec/fixtures/sample.png"
      click_button "更新"
      expect(page).to have_content "ユーザー情報を更新しました"
    end
    
    it "ユーザー情報の編集に失敗する" do
      visit login_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "専用ログイン"

      click_link "編集"
      fill_in "ユーザー名", with: ""
      fill_in "メールアドレス", with: ""
      fill_in "プロフィール", with: ""
      attach_file "プロフィール画像", "spec/fixtures/sample.png"
      click_button "更新"
      expect(page).to have_content "ユーザー情婦の更新に失敗しました"
      expect(page).to have_content "ユーザー名を入力してください"
      expect(page).to have_content "メールアドレスを入力してください"
      expect(page).to have_content "メールアドレスは不正な値です"
    end    
  end
end
