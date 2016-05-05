FactoryGirl.define do
  factory :bundle do
    bazaar_sku { FFaker::Internet.user_name }
    price 3
    coins 1
    free_coins 1
  end

end
