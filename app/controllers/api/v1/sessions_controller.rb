class Api::V1::SessionsController < Api::V1::ApiController
  skip_before_action :authenticate_with_token!, only: [:create]

  def create
    user = User.find_by uid: session_params[:uid]
    if user
      render json: user, status: 200, serializer: Api::V1::SessionSerializer
    else
      errors = { base: ["user not registered"] }
      render json: { errors: errors }, status: 404
    end
  end

  private

  def session_params
    params.require(:user).permit(:uid)
  end
end
