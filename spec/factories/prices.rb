FactoryGirl.define do
  factory :price do
    campaign_value { (rand() * 100).to_i }
    users_share { (rand() * 100).to_i }
  end

end
