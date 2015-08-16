FactoryGirl.define do
  factory :price do
    campaign_value { (rand() * 10).to_i }
    users_share { (rand() * 10).to_i }
    campaign_type "instagram"
    payment_type "money_getter"
  end

end
