FactoryGirl.define do
  factory :campaign_class do
    campaign_type "InstagramLikingCampaign"
    payment_type  "coin"
    status true
    campaign_value 5
    coin_user_share 2
    like_user_share 0
    waiting 0

    factory :instagram_liking_coin_with_waiting_class do
      campaign_type "InstagramLikingCampaign"
      payment_type  "coin"
      campaign_value 5
      coin_user_share 2
      like_user_share 10
      waiting 5
    end

    factory :instagram_liking_like_class do
      campaign_type "InstagramLikingCampaign"
      payment_type  "like"
      campaign_value 10
      coin_user_share 0
      like_user_share 5
      waiting 0
    end

    factory :instagram_liking_coin_class do
      campaign_type "InstagramLikingCampaign"
      payment_type  "coin"
      campaign_value 5
      coin_user_share 2
      like_user_share 0
      waiting 0
    end
  end

end
