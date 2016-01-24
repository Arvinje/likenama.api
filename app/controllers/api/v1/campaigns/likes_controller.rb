class Api::V1::Campaigns::LikesController < Api::V1::ApiController

  def create
    campaign = Campaign.find params[:campaign_id]
    result = CampaignLiking.new(campaign, current_user, like_params)
    if result.like!
      render json: current_user, serializer: Api::V1::UserSerializer, status: :created
    else
      if result.campaign.errors[:base].include?(t('errors.messages.access_token_invalid'))
        render json: { errors: result.campaign.errors }, status: :unauthorized
      else
        render json: { errors: result.campaign.errors }, status: :unprocessable_entity
      end
    end
  end

  private

  def like_params
    params.require(:like).permit(:instagram_access_token)
  end

end
