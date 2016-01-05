FactoryGirl.define do
  factory :message do
    user
    email FFaker::Internet.email
    name FFaker::Name.name
    content FFaker::Lorem.paragraphs
  end

end
