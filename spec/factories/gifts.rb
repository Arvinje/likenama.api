FactoryGirl.define do
  factory :gift do
    email { FFaker::Internet.email }
    coin_credit 10
    like_credit 5
    duration Date.yesterday..Date.tomorrow

    before(:create) do |gift|
      create :instagram_user, email: gift.email
    end

    factory :expired_gift do
      duration 2.days.ago.to_date..Date.current
    end
  end
end
