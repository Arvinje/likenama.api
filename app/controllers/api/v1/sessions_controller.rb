class Api::V1::SessionsController < Api::V1::ApiController
  skip_before_action :authenticate_with_token!, only: [:create]

  def create
    user = User.find_by! uid: session_params[:uid]
    render json: user, serializer: Api::V1::SessionSerializer, status: :ok
  end

  private

  def session_params
    params.require(:user).permit(:uid)
  end
end
