FactoryGirl.define do
  factory :price do
    campaign_value 50
    users_share 20
    campaign_type "instagram"
    payment_type "money_getter"
  end

end
