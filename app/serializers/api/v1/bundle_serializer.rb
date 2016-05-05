class Api::V1::BundleSerializer < ActiveModel::Serializer
  attributes :bazaar_sku, :price, :coins, :free_coins
end
