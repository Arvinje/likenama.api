FactoryGirl.define do
  factory :user do
    email { FFaker::Internet.email }
    password "12345678"
    password_confirmation "12345678"
    coin_credit { (rand() * 100000).to_i }
    like_credit { (rand() * 100000).to_i }
  end
end
