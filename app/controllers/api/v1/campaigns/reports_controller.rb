class Api::V1::Campaigns::ReportsController < Api::V1::ApiController

  def create
    campaign = Campaign.find params[:campaign_id]
    if Report.find_by(user: current_user, campaign: campaign).blank?
      campaign.reporters << current_user
      head :created
    else
      head :ok
    end
  end

end
