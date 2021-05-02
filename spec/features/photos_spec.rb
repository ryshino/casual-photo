require 'rails_helper'

RSpec.feature "Photos", type: :feature do
  before do
    user = FactoryBot.create(:user)

    visit login_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "専用ログイン"
  end
  feature "写真の投稿", js: true do
    scenario "新しい写真を投稿する" do
      visit new_photo_path
      click_link "新規投稿"
      fill_in "タイトル", with: "テスト"
      fill_in "内容", with: "内容"
      attach_file "写真", "spec/fixtures/sample.png", make_visible: true
      click_button "投稿"
      expect(page).to have_content "投稿に成功しました"
    end

    scenario "新しい写真の投稿に失敗する" do
      visit new_photo_path
      click_link "新規投稿"
      fill_in "タイトル", with: ""
      fill_in "内容", with: ""
      attach_file "写真", "spec/fixtures/sample.png", make_visible: true
      click_button "投稿"
      expect(page).to have_content "投稿に失敗しました"
    end
  end
end