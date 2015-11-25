FactoryGirl.define do
  factory :campaign do
    campaign_type "instagram"
    payment_type { ["like_getter", "money_getter"].sample }
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
      if Price.where(campaign_type: campaign.campaign_type, payment_type: campaign.payment_type).empty?
        FactoryGirl.create(:price, campaign_type: campaign.campaign_type, payment_type: campaign.payment_type)
      end
    end
    after(:build) do |campaign|
      if Waiting.where(campaign_type: campaign.campaign_type, payment_type: campaign.payment_type).empty?
        FactoryGirl.create(:waiting, campaign_type: campaign.campaign_type, payment_type: campaign.payment_type)
      end
    end
  end

end
