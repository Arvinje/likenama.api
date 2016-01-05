FactoryGirl.define do
  factory :message do
    association :user, factory: :instagram_user
    email { FFaker::Internet.email }
    name { FFaker::Name.name }
    content { FFaker::Lorem.paragraphs.join '' }
  end

end
