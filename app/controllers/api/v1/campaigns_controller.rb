class Api::V1::CampaignsController < Api::V1::ApiController

  def index
    user_campaigns = current_user.campaigns.order(created_at: :desc)
    unless user_campaigns.empty?
      render json: user_campaigns, each_serializer: Api::V1::UsersCampaignSerializer, status: :ok
    else
      handle_notfound
    end
  end

  def next
    campaign = Campaign.for_user current_user
    unless campaign.nil?
      render json: campaign, serializer: Api::V1::CampaignSerializer, status: :ok#, location: [:api, campaign]
    else
      handle_notfound
    end
  end

  def new
    render json: CampaignClass.active, each_serializer: Api::V1::CampaignClassSerializer, root: "campaign_classes", status: :ok
  end

  def create
    campaign_class = CampaignClass.active.find campaign_params[:campaign_class_id]
    creation = CreateCampaign.new(campaign_params, campaign_class, current_user)
    if creation.save
      head :created
    else
      render json: { errors: creation.campaign.errors }, status: :unprocessable_entity
    end
  end

=begin
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
=end
  private

  def campaign_params
    params.require(:campaign).permit(:campaign_class_id, :budget, :target_url, :description, :phone, :website, :address)
  end
end
