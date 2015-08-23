FactoryGirl.define do
  factory :product_detail do
    code { FFaker::Lorem.sentence }
    description { FFaker::Lorem.paragraphs }
    product
  end

end
