require 'rails_helper'

RSpec.describe User, type: :model do
  it "名前、メール、パスワードがあれば有効な状態であること" do
    user = User.new(
      name: "test",
      email:  "tester@example.com",
      password:  "password",
      password_confirmation:  "password",
    )
    expect(user).to be_valid
  end

  it "名前がなければ無効な状態であること" do
    user = User.new(name: nil)
    user.valid?
    expect(user.errors[:name]).to include("を入力してください")
  end

  it "名前が50文字以上なら無効な状態であること" do
    user = User.new(name: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    user.valid?
    expect(user.errors[:name]).to include("は50文字以内で入力してください")
  end

  it "メールアドレスがなければ無効な状態であること" do
    user = User.new(email: nil)
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end

  it "重複したメールアドレスなら無効な状態であること" do
    User.create(
      name: "test",
      email:  "tester@example.com",
      password:  "password",
      password_confirmation:  "password",
    )
    user = User.new(
      name: "test",
      email:  "tester@example.com",
      password:  "password",
      password_confirmation:  "password",
    )
    user.valid?
    expect(user.errors[:email]).to include("はすでに存在します")
  end

  it "パスワードが６文字以下なら無効な状態であること" do
    user = User.new(
      password: "123",
      password_confirmation: "123",
    )
    user.valid?
    expect(user.errors[:password]).to include("は6文字以上で入力してください")
  end

end
