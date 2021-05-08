require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { FactoryBot.create(:user) }
  
  describe "新規登録ページ" do
    before do
      visit signup_path
    end

    context "ページレイアウト" do
      it "「New User」の文字列が存在すること" do
        expect(page).to have_content "New User"
      end

      it "ナビバーに新規登録ページへのリンクがあることを確認" do
        expect(page).to have_link '新規登録', href: signup_path
      end

      it "新規登録フォームのラベルが正しく表示される" do
        expect(page).to have_content 'ユーザー名'
        expect(page).to have_content 'メールアドレス'
        expect(page).to have_content 'パスワード（６文字以上必要です）'
        expect(page).to have_content '確認用'
      end

      it "Sign upボタンが表示される" do
        expect(page).to have_button 'Sign up!'
      end
    end

    context "サインアップ処理" do
      it "新規登録する" do
        expect {
        fill_in "ユーザー名", with: "new_user"
        fill_in "メールアドレス", with: "new_user@example.com"
        fill_in "パスワード", with: "1" * 6
        fill_in "確認用", with: "1" * 6
        click_button "Sign up!"
        expect(page). to have_content "ユーザーを登録しました"
        }.to change(User, :count).by(1)
      end
  
      it "新規登録に失敗する" do
        expect {
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
        }.not_to change(User, :count)
      end
    end
  end

  describe "ユーザー編集ページ", slow: true do
    before do
      visit login_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "専用ログイン"
    end

    context "ページレイアウト" do
      it "「Edit User」の文字列が存在すること" do
        click_link "編集"
        expect(page).to have_content "Edit User"
      end
    end

    context "ユーザー編集処理" do      
      it "ユーザー情報を編集する" do
        click_link "編集"
        fill_in "ユーザー名", with: "テストユーザー"
        fill_in "メールアドレス", with: "edit@example.com"
        fill_in "プロフィール", with: "プロフィール"
        attach_file "プロフィール画像", "spec/fixtures/sample.png"
        click_button "更新"
        expect(page).to have_content "ユーザー情報を更新しました"
      end
      
      it "ユーザー情報の編集に失敗する" do  
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

  describe "ユーザー一覧ページ" do
    context "ページレイアウト" do
      it "「Users」の文字列が存在すること" do
        visit users_path
        expect(page).to have_content "Users"
      end
    end

    context "ユーザー登録している場合" do
      it "詳細画面へ移動できる" do
        visit login_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        click_button "専用ログイン"

        click_link "ユーザー一覧"
        click_link "#{user.name}"
        expect(page).to have_content "User"
        expect(page).to have_content "#{user.name}"
      end
    end
      
    context "ユーザー登録していない場合" do
      it "ログイン画面へリダイレクトされる" do  
        FactoryBot.create(:user)
        visit users_path
        click_link "#{user.name}"
        expect(page).to have_content "ログインが必要です"
        expect(page).to have_content "【採用担当者様 専用ログインフォーム】"
      end  
    end
  end
end