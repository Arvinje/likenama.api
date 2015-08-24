class Api::V1::CampaignsController < Api::V1::ApiController

  def index
    user_campaigns = current_user.campaigns
    unless user_campaigns.empty?
      render json: user_campaigns, each_serializer: Api::V1::CampaignSerializer, status: 200
    else
      errors = { base: ["no available campaign"] }
      render json: { errors: errors }, status: 422
    end
  end

  def next
    campaign = Campaign.for_user current_user
    unless campaign.nil?
      render json: campaign, serializer: Api::V1::CampaignSerializer, status: 200, location: [:api, campaign]
    else
      errors = { base: ["no available campaign"] }
      render json: { errors: errors }, status: 422
    end
  end

  def create
    campaign = current_user.campaigns.build(campaign_params)
    if campaign.save
      render json: campaign, serializer: Api::V1::CampaignSerializer, status: 201, location: [:api, campaign]
    else
      render json: { errors: campaign.errors }, status: 422
    end
  end

  def show
    render json: Campaign.find(params[:id]), serializer: Api::V1::CampaignSerializer
  end

  def update
    campaign = current_user.campaigns.find_by id: params[:id]
    if campaign
      if campaign.update(campaign_params)
        render json: campaign, serializer: Api::V1::CampaignSerializer, status: 200, location: [:api, campaign]
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
    params.require(:campaign).permit(:campaign_type, :payment_type, :budget, instagram_detail_attributes: [:short_code, :description, :phone, :website, :address, :waiting])
  end
end
