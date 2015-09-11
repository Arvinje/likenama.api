class Api::V1::CampaignsController < Api::V1::ApiController

  def index
    user_campaigns = current_user.campaigns
    unless user_campaigns.empty?
      render json: user_campaigns, each_serializer: Api::V1::UsersCampaignSerializer, status: :ok
    else
      handle_notfound
    end
  end

  def next
    campaign = Campaign.for_user current_user
    unless campaign.nil?
      render json: campaign, serializer: Api::V1::CampaignSerializer, status: :ok, location: [:api, campaign]
    else
      handle_notfound
    end
  end

  def new
    prices = Price.available_prices
    render json: prices, each_serializer: Api::V1::PriceSerializer, root: 'prices', status: 200
  end

  def create
    campaign = current_user.campaigns.build(campaign_params)
    if campaign.save
      head :created
    else
      render json: { errors: campaign.errors }, status: :unprocessable_entity
    end
  end

  def show
    render json: Campaign.find(params[:id]), serializer: Api::V1::CampaignSerializer, status: :ok
  end

  def update
    campaign = current_user.campaigns.find params[:id]
    if campaign.update(campaign_params)
      render json: campaign, serializer: Api::V1::CampaignSerializer, status: :ok, location: [:api, campaign]
    else
      render json: { errors: campaign.errors }, status: :unprocessable_entity
    end
  end

  private

  def campaign_params
    params.require(:campaign).permit(:campaign_type, :payment_type, :budget, instagram_detail_attributes: [:url, :description, :phone, :website, :address])
  end
end
