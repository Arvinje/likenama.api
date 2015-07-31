FactoryGirl.define do
  factory :campaign do
    campaign_type { ["like_getter", "money_getter"].sample }
    like_value { (rand() * 100000).to_i }
    total_likes 0
    association :owner, factory: :user
  end

end
