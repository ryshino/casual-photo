require 'rails_helper'

RSpec.describe "Photos", type: :system do
  describe "写真の投稿", js: true do
    it "新しい写真を投稿する" do
      user = FactoryBot.create(:user)
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
      user = FactoryBot.create(:user)
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
end