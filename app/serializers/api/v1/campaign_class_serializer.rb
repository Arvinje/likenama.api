class Api::V1::CampaignClassSerializer < ActiveModel::Serializer
  attributes :campaign_type, :payment_type, :campaign_value, :coin_user_share, :like_user_share ,:waiting

  def campaign_type
    object.campaign_type.chomp("Campaign").underscore
  end

end
