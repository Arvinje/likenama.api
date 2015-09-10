FactoryGirl.define do
  factory :campaign do
    campaign_type "instagram"
    payment_type { ["like_getter", "money_getter"].sample }
    like_value { (rand() * 100000).to_i }
    total_likes 0
    available true
    verified true
    price
    waiting
    budget 1000
    association :owner, factory: :user
    after(:build) do |campaign|
      campaign.instagram_detail ||= FactoryGirl.create(:instagram_detail, campaign: campaign)
    end
    after(:build) do |campaign|
      FactoryGirl.create(:price, campaign_type: campaign.campaign_type, payment_type: campaign.payment_type)
    end
    after(:build) do |campaign|
      FactoryGirl.create(:waiting, campaign_type: campaign.campaign_type, payment_type: campaign.payment_type)
    end
  end

end
