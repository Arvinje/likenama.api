class Api::V1::UsersCampaignSerializer < ActiveModel::Serializer
  attributes :id, :target_url, :campaign_type, :payment_type, :status, :budget, :total_likes

  def status
    object.status
  end

  def payment_type
    object.campaign_class.payment_type
  end

  def campaign_type
    object.type.chomp("Campaign").underscore
  end

end
