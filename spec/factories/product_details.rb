FactoryGirl.define do
  factory :product_detail do
    code { FFaker::Lorem.sentence }
    available true
    product
  end

end
