FactoryBot.define do
  factory :comment do
    comment { "test comment" }
    association :photo
    association :user
  end
end
