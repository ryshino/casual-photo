FactoryBot.define do
  factory :photo do
    title "テスト"
    body "内容"
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/fixtures/sample.png"), 'image/png') }
    association :user

    trait :with_comments do
      after(:create) { |photo| create_list(:comment, 5, photo: photo) }
    end

    trait :invalid do
      title nil
    end
  end
end
