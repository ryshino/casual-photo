FactoryBot.define do
  factory :photo do
    title "テスト"
    body "内容"
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/fixtures/sample.png"), 'image/png') }
    association :user
  end
end
