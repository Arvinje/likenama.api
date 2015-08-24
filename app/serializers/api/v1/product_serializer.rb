class Api::V1::ProductSerializer < ActiveModel::Serializer
  attributes :id, :title, :price, :description
end
