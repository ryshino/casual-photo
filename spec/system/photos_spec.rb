require 'rails_helper'

RSpec.describe "Photos", type: :system do
  let(:user) { FactoryBot.create(:user) }

  describe "写真の投稿", js: true, slow: true do
    it "新しい写真を投稿する" do
      visit login_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "専用ログイン"

      visit new_photo_path
      fill_in "タイトル", with: "テスト"
      fill_in "内容", with: "内容"
      attach_file "写真", "spec/fixtures/sample.png", make_visible: true
      click_button "投稿"
      expect(page).to have_content "投稿に成功しました"
    end

    it "新しい写真の投稿に失敗する" do
      visit login_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "専用ログイン"

      visit new_photo_path
      fill_in "タイトル", with: ""
      fill_in "内容", with: ""
      attach_file "写真", "spec/fixtures/sample.png", make_visible: true
      click_button "投稿"
      expect(page).to have_content "投稿に失敗しました"
    end
  end

  describe "ユーザー一覧ページ",js: true do
    let!(:photo) { FactoryBot.create(:photo) }

    context "ページレイアウト" do
      it "「Photos」の文字列が存在すること" do
        visit photos_path
        expect(page).to have_content "Photos"
      end
    end

    context "ユーザー登録している場合" do
      it "詳細画面へ移動できる" do
        visit login_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        click_button "専用ログイン"

        visit photos_path
        find(".card-image").click
        expect(page).to have_content "#{ photo.title}"
      end
    end

    context "ユーザー登録していない場合" do
      it "ログイン画面へリダイレクトされる" do  
        visit photos_path
        find(".card-image").click
        expect(page).to have_content "ログインが必要です"
        expect(page).to have_content "【採用担当者様 専用ログインフォーム】"
      end  
    end
  end
end