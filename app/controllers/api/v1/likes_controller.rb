class Api::V1::LikesController < Api::V1::ApiController

  def create
    campaign = Campaign.find params[:campaign_id]
    if campaign.check_like!(current_user, like_params)
      render json: current_user, serializer: Api::V1::UserSerializer, status: :created
    else
      render json: { errors: campaign.errors }, status: :unprocessable_entity
    end
  end

  private

  def like_params
    params.require(:like).permit(:instagram_access_token)
  end

end
