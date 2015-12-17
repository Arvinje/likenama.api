FactoryGirl.define do
  factory :user do
    email { FFaker::Internet.email }
    password "12345678"
    password_confirmation "12345678"
    coin_credit 10000
    like_credit 20000
    factory :instagram_user do
      provider "instagram"
      omni_id "46569725"
      username { FFaker::Internet.user_name }
    end
  end
end
