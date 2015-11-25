class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :username, :like_credit, :coin_credit
end
