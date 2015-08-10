class Api::V1::LikesController < Api::V1::ApiController
  before_action :authenticate_with_token!

  def create
    campaign = Campaign.find_by id: params[:campaign_id]
    unless campaign.nil?
      if campaign.check_like!(current_user, like_params)
        render json: current_user, status: 201
      else
        render json: { errors: campaign.errors }, status: 422
      end
    else
      errors = { base: ["the requested campaign could not be found"] }
      render json: { errors: errors }, status: 422
    end
  end

  private

  def like_params
    params.require(:like).permit(:instagram_access_token)
  end

end
