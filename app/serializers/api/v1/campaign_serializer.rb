class Api::V1::CampaignSerializer < ActiveModel::Serializer
  attributes :id, :campaign_type, :payment_type, :value, :waiting

  def value
    object.price.users_share
  end

  def waiting
    object.waiting.period
  end

  has_one :instagram_detail
end
