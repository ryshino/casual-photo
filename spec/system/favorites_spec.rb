require 'rails_helper'

RSpec.describe  "Favorites", type: :system do
  describe "いいね機能", js: true do
    let(:user) { FactoryBot.create(:user) }
    let!(:photo) { FactoryBot.create(:photo) }
    before do
      visit login_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "専用ログイン"

      visit photos_path
    end

    it "いいねのカウントが1増えること" do
      expect {
        find(".unlike").click
        expect(page).to have_content "Photos"
      }.to change(photo.favorites, :count).by(1)
    end

    it "いいねのカウントが1減ること" do
      find(".unlike", visible: false).click
      expect(page).to have_content "Photos"
      expect {
        find(".like", visible: false).click
        expect(page).to have_content "Photos"
      }.to change(photo.favorites, :count).by(-1)
    end
  end
end