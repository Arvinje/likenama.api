class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :uid, :like_credit, :coin_credit
end
