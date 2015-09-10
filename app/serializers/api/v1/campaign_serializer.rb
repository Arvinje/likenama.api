class Api::V1::CampaignSerializer < ActiveModel::Serializer
  attributes :id, :campaign_type, :value

  def value
    object.price.users_share
  end

  has_one :instagram_detail
end
