class Api::V1::ProductSerializer < ActiveModel::Serializer
  attributes :id, :title, :product_type, :price, :description

  def product_type
    object.product_type.name
  end
end
