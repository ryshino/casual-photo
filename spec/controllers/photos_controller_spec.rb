require 'rails_helper'

RSpec.describe PhotosController, type: :controller do
  describe "#index" do
    it "正常にレスポンスを返すこと" do
      get :index
      expect(response).to be_success
    end

    it "200レスポンスを返すこと" do
      get :index
      expect(response).to have_http_status "200"
    end
  end

  describe "#show" do
    context "ユーザー登録している場合" do
      before do
        @user = FactoryBot.create(:user)
        @photo = FactoryBot.create(:photo)
      end

      it "正常にレスポンスを返すこと" do
        login @user
        get :show, params:{id: @photo.id}
        expect(response).to be_success
      end
    end

    context "ユーザー登録していない場合" do
      before do
        @photo = FactoryBot.create(:photo)
      end

      it "ログイン画面にリダイレクトされること" do
        get :show, params:{id: @photo.id}
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "#create" do
    context "ユーザー登録している場合" do
      before do
        @user = FactoryBot.create(:user)
      end

      context "有効な属性値の場合" do
        it "写真を追加できること" do
          photo_params = FactoryBot.attributes_for(:photo)
          login @user
          expect {
            post :create,params: { photo: photo_params }
          }.to change(@user.photos, :count).by(1)
        end
      end

      context "無効な属性値の場合" do
        it "写真を追加できないこと" do
          photo_params = FactoryBot.attributes_for(:photo, :invalid)
          login @user
          expect {
            post :create,params: { photo: photo_params }
          }.to_not change(@user.photos, :count)          
        end
      end
    end
    
    context "ユーザー登録していない場合" do
      it "302レスポンスを返すこと" do
        photo_params = FactoryBot.attributes_for(:photo)
        post :create,params: { photo: photo_params }
        expect(response).to have_http_status "302"
      end

      it "ログイン画面にリダイレクトされること" do
        photo_params = FactoryBot.attributes_for(:photo)
        post :create,params: { photo: photo_params }
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "#update" do
    context "ユーザー登録している場合" do
      before do
        @user = FactoryBot.create(:user)
        @photo = FactoryBot.create(:photo, user_id: @user.id)
      end

      it "写真の更新ができること" do
        photo_params = FactoryBot.attributes_for(:photo,
        title: "new title")
        login @user
        patch :update, params: { id: @photo.id, photo: photo_params }
        expect(@photo.reload.title).to eq "new title"
      end
    end

    context "更新が許可されていないユーザーの場合" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @photo = FactoryBot.create(:photo,
        user_id: other_user.id,
        title: "old title")
      end

      it "写真を更新できないこと" do
        photo_params = FactoryBot.attributes_for(:photo,
        title: "new title")
        login @user
        patch :update, params: { id: @photo.id, photo: photo_params }
        expect(@photo.reload.title).to eq "old title"
      end

     it "リダイレクトされること" do
       photo_params = FactoryBot.attributes_for(:photo)
       login @user
       patch :update, params: { id: @photo.id, photo: photo_params }
       expect(response).to redirect_to root_url
     end
    end

    context "ユーザー登録していない場合" do
      before do
        @photo = FactoryBot.create(:photo)
      end
      
      it "302レスポンスを返すこと" do
        patch :update, params: { id: @photo.id }
        expect(response).to have_http_status "302"
      end

      it "ログイン画面にリダイレクトされること" do
        patch :update, params: { id: @photo.id }
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "#destroy" do
    context "ユーザー登録されている場合" do
      before do
        @user = FactoryBot.create(:user)
        @photo = FactoryBot.create(:photo, user_id: @user.id)
      end
      
      it "写真を削除できること" do
        login @user
        expect {
          delete :destroy, params: { id: @photo.id }
        }.to change(@user.photos, :count).by(-1)
      end
    end

    context "許可されていないユーザーの場合" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @photo = FactoryBot.create(:photo,user_id: other_user.id)
      end

      it "写真を削除できないこと" do
        login @user
        expect {
          delete :destroy, params: { id: @photo.id }
        }.to_not change(Photo, :count)
      end
      
      it "リダイレクトされること" do
        photo_params = FactoryBot.attributes_for(:photo)
        login @user
        delete :destroy, params: { id: @photo.id, photo: photo_params }
        expect(response).to redirect_to root_url
      end
    end

    context "ユーザー登録されていない場合" do
      before do
        @photo = FactoryBot.create(:photo)
      end

      it "302レスポンスを返すこと" do
        delete :destroy, params: { id: @photo.id }
        expect(response).to have_http_status "302"
      end

      it "ログイン画面にリダイレクトされること" do
        delete :destroy, params: { id: @photo.id }
        expect(response).to redirect_to login_path
      end

      it "写真を削除できないこと" do
        expect {
          delete :destroy, params: { id: @photo.id }
        }.to_not change(Photo, :count)
      end
    end
  end
end
