FactoryGirl.define do
  factory :campaign do
    campaign_type "instagram"
    payment_type { ["like_getter", "money_getter"].sample }
    like_value { (rand() * 100000).to_i }
    total_likes 0
    price
    association :owner, factory: :user
    after(:build) do |campaign|
      campaign.instagram_detail ||= FactoryGirl.build(:instagram_detail, campaign: campaign)
    end
  end

end
