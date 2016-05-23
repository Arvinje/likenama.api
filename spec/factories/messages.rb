FactoryGirl.define do
  factory :message do
    association :user, factory: :instagram_user
    email { FFaker::Internet.email }
    title { FFaker::Internet.email }
    content { FFaker::Lorem.paragraphs.first(1).join('') }
    read false

    factory :invalid_message do
      content { FFaker::Lorem.paragraphs.join('\n') + FFaker::Lorem.paragraphs.join('\n') }
    end
  end

end
