FactoryGirl.define do
  factory :product do
    title { FFaker::Product.product_name }
    product_type
    description { FFaker::Lorem.paragraph }
    price { (rand()*100).to_i }

    factory :product_with_details do
      transient do
        details_count 3
      end

      after :create do |product, evaluator|
        create_list :product_detail, evaluator.details_count, product: product
      end
    end
  end

end
