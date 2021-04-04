require 'rails_helper'

RSpec.feature "Photos", type: :feature do
  scenario "ユーザーは新しいプロジェクトを作成する" do
    user = FactoryBot.create(:user)

    visit login_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "Log in"

    expect {
      click_link "新規投稿"
      fill_in "タイトル", with: "テスト"
      fill_in "内容", with: "内容"
      attach_file "写真", "spec/fixtures/sample.png"                            
      click_button "投稿"

      expect(page).to have_content "投稿に成功しました"
    }.to change(user.photos, :count).by(1)
  end
end
