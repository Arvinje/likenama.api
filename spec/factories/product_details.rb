FactoryGirl.define do
  factory :product_detail do
    code { FFaker::Lorem.sentence }
    available [true, false].sample
    product
  end

end
