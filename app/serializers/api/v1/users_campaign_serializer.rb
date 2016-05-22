class Api::V1::UsersCampaignSerializer < ActiveModel::Serializer
  attributes :id, :target_url, :campaign_type, :payment_type, :status, :budget, :total_likes

  def status
    I18n.t "campaign_status.#{object.status}"
  end

end
