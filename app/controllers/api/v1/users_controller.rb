class Api::V1::UsersController < Api::V1::ApiController
  def self
    render json: current_user, serializer: Api::V1::UserSerializer, status: 200
  end
end
