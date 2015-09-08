FactoryGirl.define do
  factory :instagram_detail do
    short_code { Rails.application.secrets.not_liked_instagram_shortcode }
    description { FFaker::Lorem.paragraph }
    phone { (rand() * 10**8).round.to_s }
    website { FFaker::Internet.http_url }
    address { FFaker::AddressAU.full_address }
    campaign
  end

end
