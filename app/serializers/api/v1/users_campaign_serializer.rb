class Api::V1::UsersCampaignSerializer < ActiveModel::Serializer
  attributes :id, :target_url, :campaign_type, :payment_type, :status, :budget, :total_likes
end
