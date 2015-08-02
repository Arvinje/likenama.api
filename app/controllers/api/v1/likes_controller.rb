class Api::V1::LikesController < Api::V1::ApiController
  respond_to :json
  before_action :authenticate_with_token!

  def create
    campaign = Campaign.find(params[:campaign_id])
    if campaign.like current_user
      head 201
    else
      render json: { error: "cannot get liked" }, status: 422
    end
  end


end
