FactoryGirl.define do
  factory :campaign do
    type 1
    like_value { (rand() * 100000).to_i }
    total_likes 0
  end

end
