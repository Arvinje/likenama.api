class Api::V1::ProductSerializer < ActiveModel::Serializer
  attributes :id, :title, :product_type, :price, :description
end
