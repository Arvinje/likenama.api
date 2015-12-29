class Api::V1::UsersCampaignSerializer < ActiveModel::Serializer
  attributes :id, :url, :campaign_type, :payment_type, :status, :budget, :total_likes

  def status
    object.status
  end

  def url
    object.detail.get_url
  end

end
