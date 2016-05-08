class Api::V1::CampaignClassSerializer < ActiveModel::Serializer
  attributes :campaign_type, :payment_type, :waiting, :max_user_likes, :campaign_value, :fields

  def campaign_type
    object.campaign_type.chomp("Campaign").underscore
  end

  def max_user_likes
    scope.send("#{payment_type}_credit") / campaign_value
  end

end
