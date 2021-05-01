require 'rails_helper'

RSpec.feature "Users", type: :feature do
  feature "ログインページ" do
    before do
      visit login_path
    end

    scenario "ログインをする" do
      user = FactoryBot.create(:user)
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "専用ログイン"
      expect(page).to have_content "ログインに成功しました"
    end

    scenario "ログインに失敗する" do
      fill_in "メールアドレス", with: ""
      fill_in "パスワード", with: ""
      click_button "専用ログイン"
      expect(page).to have_content "メールアドレスもしくはパスワードの入力に誤りがあります"      
    end
  
    scenario "ログアウトする" do
      user = FactoryBot.create(:user)
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "専用ログイン"
      
      click_link "ログアウト"
      expect(page).to have_content "ログアウトしました"
    end
  end


  feature "ユーザー登録ページ" do
    before do
      visit signup_path
    end

    scenario "新規登録する" do
      fill_in "ユーザー名", with: "new_user"
      fill_in "メールアドレス", with: "new_user@example.com"
      fill_in "パスワード", with: "1" * 6
      fill_in "確認用", with: "1" * 6
      click_button "Sign up!"
      expect(page). to have_content "ユーザーを登録しました"
    end

    scenario "新規登録に失敗する" do
      fill_in "ユーザー名", with: ""
      fill_in "メールアドレス", with: "new_user@example.com"
      fill_in "パスワード", with: "1" * 6
      fill_in "確認用", with: "2" * 6
      click_button "Sign up!"
      expect(page). to have_content "ユーザーの登録に失敗しました"
      expect(page). to have_content "ユーザー名を入力してください"
      expect(page). to have_content "パスワード(確認)とパスワードの入力が一致しません"
    end
  end

  feature "ユーザー編集ページ" do
    before do
      visit login_path
    end
    
    scenario "ユーザー情報を編集する" do
      user = FactoryBot.create(:user)

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
    
    scenario "ユーザー情報の編集に失敗する" do
      user = FactoryBot.create(:user)

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
