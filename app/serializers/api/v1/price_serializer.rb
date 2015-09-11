class Api::V1::PriceSerializer < ActiveModel::Serializer
  attributes :campaign_type, :payment_type, :campaign_value
end
