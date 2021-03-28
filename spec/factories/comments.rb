FactoryBot.define do
  factory :comment do
    comment "test comment"
    association :photo
    user_id {photo.user.id}
  end
end
