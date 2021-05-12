require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let!(:favorite) { FactoryBot.create(:favorite) }

  it "favoriteインスタンスが有効であること" do
    expect(favorite).to be_valid
  end

  it "user_idがnilの場合、無効であること" do
    favorite.user_id = nil
    expect(favorite).to_not be_valid
  end

  it "photo_idがnilの場合、無効であること" do
    favorite.photo_id = nil
    expect(favorite).to_not be_valid
  end
end