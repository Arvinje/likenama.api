class Api::V1::CampaignSerializer < ActiveModel::Serializer
  attributes :id, :payment_type, :value, :waiting, :description, :phone, :website, :address

  def value
    object.campaign_class.send("#{object.campaign_class.payment_type}_user_share")
  end

  def waiting
    object.campaign_class.waiting
  end
end
