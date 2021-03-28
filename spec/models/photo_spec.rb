require 'rails_helper'

RSpec.describe Photo, type: :model do

  it "写真が保存されること" do
    photo = FactoryBot.build(:photo)
    photo.valid?
    expect(photo).to be_valid
  end
  
  it "タイトルがなければ無効であること" do
    photo = Photo.new(title: nil)
    photo.valid?
    expect(photo.errors[:title]).to include("を入力してください")
  end

  it "内容がなければ無効であること" do
    photo = Photo.new(body: nil)
    photo.valid?
    expect(photo.errors[:body]).to include("を入力してください")
  end
  
  it "写真がなければ無効であること" do
    photo = Photo.new(image: nil)
    photo.valid?
    expect(photo.errors[:image]).to include("を入力してください")
  end

  it "タイトルが20文字以上なら無効であること" do
    photo = Photo.new(title: "a" * 21)
    photo.valid?
    expect(photo.errors[:title]).to include("は20文字以内で入力してください")
  end

  it "内容が150文字以上なら無効であること" do
    photo = Photo.new(body: "a" * 151)
    photo.valid?
    expect(photo.errors[:body]).to include("は150文字以内で入力してください")
  end
 end
