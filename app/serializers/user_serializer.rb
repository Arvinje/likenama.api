class UserSerializer < ActiveModel::Serializer
  attributes :id, :uid, :like_credit, :coin_credit
end
