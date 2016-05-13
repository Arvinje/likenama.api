FactoryGirl.define do
  factory :message do
    association :user, factory: :instagram_user
    content { FFaker::Lorem.paragraphs.first(2).join('\n') }
    read false
  end

end
