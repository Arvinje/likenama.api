FactoryGirl.define do
  factory :campaign do
    campaign_type "instagram"
    payment_type { ["like_getter", "money_getter"].sample }
    like_value { (rand() * 100000).to_i }
    total_likes 0
    price
    budget { (rand() * 10000).to_i }
    association :owner, factory: :user
    after(:build) do |campaign|
      campaign.instagram_detail ||= FactoryGirl.build(:instagram_detail, campaign: campaign)
    end
    after(:build) do |campaign|
      campaign.price = FactoryGirl.create(:price, campaign_type: campaign.campaign_type, payment_type: campaign.payment_type)
    end
  end

end
