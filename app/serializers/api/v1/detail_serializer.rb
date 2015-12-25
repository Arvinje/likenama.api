class Api::V1::DetailSerializer < ActiveModel::Serializer
  attributes :code
  has_one    :product, root: :product
end
