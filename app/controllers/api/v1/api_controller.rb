class Api::V1::ApiController < ActionController::Base
  respond_to :json
  protect_from_forgery with: :null_session

  include Authenticable

  before_action :authenticate_with_token!

  rescue_from ActiveRecord::RecordNotFound, with: :handle_notfound

  protected
  
  def handle_notfound
    errors = { base: ["مورد درخواست‌شده یافت نشد"] }
    render json: { errors: errors }, status: 404
  end

end
