require 'rails_helper'

RSpec.describe "Photos", type: :system do
  let(:user) { FactoryBot.create(:user) }

  describe "写真の投稿", js: true do
    before do
      visit login_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "専用ログイン"

      visit new_photo_path
    end

    context "ページレイアウト" do
      it "正しいタイトルが表示されること" do
        expect(page).to have_content "New Photo"
      end

      it "入力部分に適切なラベルが表示されること" do
        expect(page).to have_content "タイトル"
        expect(page).to have_content "内容"
        expect(page).to have_content "写真"
        expect(page).to have_content "公開範囲"
      end
    end
    
    context "投稿処理" do
      it "新しい写真を投稿する" do
        fill_in "タイトル", with: "テスト"
        fill_in "内容", with: "内容"
        attach_file "写真", "spec/fixtures/sample.png", make_visible: true
        select "全体公開", from: "公開範囲"
        click_button "投稿"
        expect(page).to have_content "投稿に成功しました"
      end
  
      it "新しい写真の投稿に失敗する" do
        fill_in "タイトル", with: ""
        fill_in "内容", with: ""
        attach_file "写真", "spec/fixtures/sample.png", make_visible: true
        select "全体公開", from: "公開範囲"
        click_button "投稿"
        expect(page).to have_content "投稿に失敗しました"
      end
    end
  end

  describe "写真一覧ページ",js: true do
    let!(:photo) { FactoryBot.create(:photo) }

    context "ページレイアウト" do
      it "「Photos」の文字列が存在すること" do
        visit photos_path
        expect(page).to have_content "Photos"
      end
    end

    context "ユーザー登録している場合" do
      before do
        visit login_path
        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        click_button "専用ログイン"
        
        visit photos_path
      end

      it "詳細画面へ移動できる" do
        find(".card-image").click
        expect(page).to have_content "#{ photo.title}"
      end

      it "公開範囲が「ログインユーザーのみ」の写真が表示されること" do
        login_user = FactoryBot.create(:user, name: "ログインユーザーの写真")
        FactoryBot.create(:photo, user_id: login_user.id, status: 1)
        visit photos_path
        expect(page).to have_content "ログインユーザーの写真"
      end
    end

    context "ユーザー登録していない場合" do
      it "ログイン画面へリダイレクトされる" do  
        visit photos_path
        find(".card-image").click
        expect(page).to have_content "ログインが必要です"
        expect(page).to have_content "【採用担当者様 専用ログインフォーム】"
      end
      
      it "公開範囲が「ログインユーザーのみ」の写真は表示されないこと" do
        login_user = FactoryBot.create(:user, name: "ログインユーザーの写真")
        FactoryBot.create(:photo, user_id: login_user.id, status: 1)
        visit photos_path
        expect(page).to_not have_content "ログインユーザーの写真"
      end
    end
  end

  describe "写真詳細ページ" do
    let!(:photo) { FactoryBot.create(:photo) }

    before do
      visit login_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "専用ログイン"

      visit photo_path(photo)
    end

    context "ページレイアウト" do
      it "タイトルが表示されること" do
        expect(page).to have_content "#{ photo.title }"
      end
    end
  end

  describe "写真編集ページ" do
    let!(:photo) { FactoryBot.create(:photo, user_id: user.id) }

    before do
      visit login_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "専用ログイン"

      visit edit_photo_path(photo)
    end

    context "ページレイアウト" do
      it "正しいタイトルが表示されること" do
        expect(page).to have_content "Edit Photo"
      end

      it "入力部分に適切なラベルが表示されること" do
        expect(page).to have_content "タイトル"
        expect(page).to have_content "内容"
        expect(page).to have_content "写真"
        expect(page).to have_content "公開範囲"
      end
    end

    context "写真の更新処理", js: true do
      it "有効な更新" do
        fill_in "タイトル", with: "編集したテスト"
        fill_in "内容", with: "編集した内容"
        attach_file "写真", "spec/fixtures/sample.png", make_visible: true
        select "ログインユーザーのみ", from: "公開範囲"
        click_button "更新"
        expect(page).to have_content "更新に成功しました"
        expect(photo.reload.title).to eq "編集したテスト"
        expect(photo.reload.body).to eq "編集した内容"
        expect(photo.reload.status).to eq "closed"
      end

      it "無効な更新" do
        fill_in "タイトル", with: ""
        fill_in "内容", with: ""
        attach_file "写真", "spec/fixtures/sample.png", make_visible: true
        select "全体公開", from: "公開範囲"
        click_button "更新"
        expect(page).to have_content "更新に失敗しました"
      end
    end
  end

  describe "写真の削除" do
    let!(:photo) { FactoryBot.create(:photo, user_id: user.id) }

    before do
      visit login_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "専用ログイン"

      visit user_path(user)
    end

    context "ページレイアウト" do
      it "投稿者の場合、削除ボタンが表示される" do
        expect(page).to have_content "削除"
      end

      it "投稿者でない場合、削除ボタンが表示されない" do
        other_user = FactoryBot.create(:user)
        visit login_path
        fill_in "メールアドレス", with: other_user.email
        fill_in "パスワード", with: other_user.password
        click_button "専用ログイン"

        visit user_path(user)
        expect(page).to_not have_content "削除"
      end
    end

    context "削除処理" do
      it "正常に削除される" do
        expect {
          click_link "この写真を削除する"
          expect(page).to have_content "投稿を削除しました"
        }.to change{ Photo.count }.by(-1)
      end
    end
  end
end