class Api::V1::CampaignSerializer < ActiveModel::Serializer
  attributes :id, :payment_type, :coin_user_share, :like_user_share, :waiting, :cover, :description, :phone, :website, :address

  def coin_user_share
    object.campaign_class.coin_user_share
  end

  def like_user_share
    object.campaign_class.like_user_share
  end

  def waiting
    object.campaign_class.waiting
  end

  def cover
    'http://likenama.com' + object.cover.url
  end

end
