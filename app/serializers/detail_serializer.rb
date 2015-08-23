class DetailSerializer < ActiveModel::Serializer
  attributes :code, :description
  has_one    :product, root: :product
end
