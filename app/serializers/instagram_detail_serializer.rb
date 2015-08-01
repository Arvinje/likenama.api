class InstagramDetailSerializer < ActiveModel::Serializer
  attributes :id, :short_code, :description, :phone, :website, :address, :waiting
end
