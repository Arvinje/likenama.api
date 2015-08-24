class Api::V1::InstagramDetailSerializer < ActiveModel::Serializer
  attributes :short_code, :description, :phone, :website, :address
end
