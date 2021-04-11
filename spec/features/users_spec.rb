require 'rails_helper'

RSpec.feature "Users", type: :feature do
  scenario "ログインをする" do
    user = FactoryBot.create(:user)

    visit login_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "専用ログイン"
    expect(page).to have_content "ログインに成功しました"
  end

  scenario "ログアウトする" do
    user = FactoryBot.create(:user)

    visit login_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "専用ログイン"
    
    click_link "ログアウト"
    expect(page).to have_content "ログアウトしました"
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
end
