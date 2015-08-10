class Api::V1::CampaignsController < Api::V1::ApiController
  before_action :authenticate_with_token!

  def index
    render json: Campaign.all
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
    render json: Campaign.find(params[:id])
  end

  def update
    campaign = current_user.campaigns.find_by id: params[:id]
    if campaign
      if campaign.update(campaign_params)
        render json: campaign, status: 200, location: [:api, campaign]
      else
        render json: { errors: campaign.errors }, status: 422
      end
    else
      errors = { base: ["the requested campaign could not be found"] }
      render json: { errors: errors }, status: 422
    end
  end

  private

  def campaign_params
    params.require(:campaign).permit(:campaign_type, :payment_type, :like_value, instagram_detail_attributes: [:short_code, :description, :phone, :website, :address, :waiting])
  end
end
