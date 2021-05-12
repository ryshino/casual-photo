FactoryBot.define do
  factory :favorite do
    association :photo
    association :user
  end
end