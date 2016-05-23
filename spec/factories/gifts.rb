FactoryGirl.define do
  factory :gift do
    email { FFaker::Internet.email }
    coin_credit 10
    like_credit 5
    duration Date.yesterday..Date.tomorrow
    status 'available'
    factory :expired_gift do
      duration 2.days.ago.to_date..Date.current
    end
  end
end
