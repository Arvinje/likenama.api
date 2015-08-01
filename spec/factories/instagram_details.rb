FactoryGirl.define do
  factory :instagram_detail do
    short_code { Devise.friendly_token[0,10] }
    description { FFaker::Lorem.paragraph }
    phone { (rand() * 10**8).round.to_s }
    website { FFaker::Internet.http_url }
    address { FFaker::AddressAU.full_address }
    waiting { rand(0..20) }
    campaign
  end

end
