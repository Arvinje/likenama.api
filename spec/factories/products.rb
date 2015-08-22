FactoryGirl.define do
  factory :product do
    title { FFaker::Product.product_name }
    description { FFaker::Lorem.paragraph }
    price { (rand()*10000).to_i }
    product_detail
  end

end
