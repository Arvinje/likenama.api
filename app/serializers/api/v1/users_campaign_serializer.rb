class Api::V1::UsersCampaignSerializer < ActiveModel::Serializer
  attributes :id, :campaign_type, :payment_type, :available, :verified, :budget, :total_likes, :created_at
end
