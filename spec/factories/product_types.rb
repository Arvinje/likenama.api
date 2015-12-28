FactoryGirl.define do
  factory :product_type do
    name { FFaker::Product.product_name + rand(100).to_s }
  end
end
