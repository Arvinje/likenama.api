FactoryGirl.define do
  factory :bundle_purchase do
    user
    bundle
    bazaar_purhcase_token "SomevalidPurchaseToken"
  end
end
