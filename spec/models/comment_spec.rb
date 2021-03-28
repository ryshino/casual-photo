require 'rails_helper'

RSpec.describe Comment, type: :model do
  it "コメントが保存されること" do
    comment = FactoryBot.build(:comment)
    comment.valid?
    expect(comment).to be_valid
  end

  it "コメントがなければ無効であること" do
    comment = Comment.new(comment: nil)
    comment.valid?
    expect(comment.errors[:comment]).to include("を入力してください")
  end

  it "コメントが50文字以上なら無効であること" do
    comment = Comment.new(comment: "a" * 51)
    comment.valid?
    expect(comment.errors[:comment]).to include("は50文字以内で入力してください")
  end
end
