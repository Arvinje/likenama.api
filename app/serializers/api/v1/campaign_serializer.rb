class Api::V1::CampaignSerializer < ActiveModel::Serializer
  attributes :id, :payment_type, :value, :waiting, :description, :phone, :website, :address

  def value
    object.price.users_share
  end

  def waiting
    object.waiting.period
  end
end
