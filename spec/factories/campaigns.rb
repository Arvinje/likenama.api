FactoryGirl.define do
  factory :campaign do
    type "InstagramLikingCampaign"
    status 'available'
    budget 1000
    payment_type { ["like_getter", "money_getter"].sample }
    association :owner, factory: :instagram_user
    description { FFaker::Lorem.paragraph }
    phone { (rand() * 10**8).round.to_s }
    website { FFaker::Internet.http_url }
    address { FFaker::AddressAU.full_address }
    total_likes 0
    after(:build) do |campaign|
      unless Price.exists?(campaign_type: campaign.type, payment_type: campaign.payment_type)
        FactoryGirl.create(:price, campaign_type: campaign.type, payment_type: campaign.payment_type)
      end
    end
    after(:build) do |campaign|
      unless Waiting.exists?(campaign_type: campaign.type, payment_type: campaign.payment_type)
        FactoryGirl.create(:waiting, campaign_type: campaign.type, payment_type: campaign.payment_type)
      end
    end
  end

  factory :instagram_campaign_service, parent: :campaign, class: "InstagramCampaignService" do
    target_url { "https://instagram.com/p/#{Rails.application.secrets.liked_instagram_shortcode}" }
    target  { Rails.application.secrets.liked_instagram_shortcode }
  end

  factory :instagram_liking_campaign, parent: :instagram_campaign_service, class: "InstagramLikingCampaign" do
  end

end
