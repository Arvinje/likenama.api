FactoryGirl.define do
  factory :campaign do
    campaign_type { [0,1].sample.to_i }
    like_value { (rand() * 100000).to_i }
    total_likes 0
    association :owner, factory: :user
  end

end
