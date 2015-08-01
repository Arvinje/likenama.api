class CampaignSerializer < ActiveModel::Serializer
  attributes :id, :campaign_type, :like_value
  has_one :instagram_detail
end
