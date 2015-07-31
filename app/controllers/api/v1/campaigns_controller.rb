class Api::V1::CampaignsController < Api::V1::ApiController
  respond_to :json
  before_action :authenticate_with_token!

  def index
    respond_with Campaign.all
  end

  def create
    campaign = current_user.campaigns.build(campaign_params)
    if campaign.save
      render json: campaign, status: 201, location: [:api, campaign]
    else
      render json: { errors: campaign.errors }, status: 422
    end
  end

  def show
    respond_with Campaign.find(params[:id])
  end

  private

  def campaign_params
    params.require(:campaign).permit(:campaign_type, :like_value, instagram_detail_attributes: [:id, :short_code, :description, :phone, :website, :address, :waiting])
  end
end
