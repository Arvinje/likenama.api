FactoryGirl.define do
  factory :message do
    association :user, factory: :instagram_user
    email { FFaker::Internet.email }
    content { FFaker::Lorem.paragraphs.first(2).join('\n') }
    read false

    factory :invalid_message do
      content { FFaker::Lorem.paragraphs.join('\n') + FFaker::Lorem.paragraphs.join('\n') }
    end
  end

end
