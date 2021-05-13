require 'rails_helper'

RSpec.describe  "Comments", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let!(:photo) { FactoryBot.create(:photo) }
  before do
    visit login_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "専用ログイン"
    visit photo_path(photo)
  end

  context "コメントの作成者の場合", js: true do
    it "コメントを作成する" do
      find(".textarea").set("テストコメント")
      click_button "コメント"
      expect(page).to have_content "テストコメント"
    end

    it "コメントを削除する" do
      find(".textarea").set("テストコメント")
      click_button "コメント"
      click_link "削除"
      expect(page).to_not have_content "テストコメント`"
    end
  end

  context "コメントを作成していない人の場合", js: true do
    let(:other_user) { FactoryBot.create(:user) }

    it "削除ボタンが表示されない" do
      find(".textarea").set("テストコメント")
      click_button "コメント"

      visit login_path
      fill_in "メールアドレス", with: other_user.email
      fill_in "パスワード", with: other_user.password
      click_on "専用ログイン"

      visit photo_path(photo)
      expect(page).to_not have_link "削除"
    end
  end
end
