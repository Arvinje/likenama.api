FactoryGirl.define do
  factory :product_type do
    name { FFaker::Product.product_name }
  end
end
