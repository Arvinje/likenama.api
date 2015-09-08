module Authenticable

  # Devise methods overwrites
  def current_user
    @current_user ||= User.find_by(auth_token: request.headers['Authorization'])
  end

  def authenticate_with_token!
    errors = { base: ["not authenticated"] }
    render json: { errors: errors },
                status: :unauthorized unless current_user.present?
  end

  def user_signed_in?
    current_user.present?
  end

end
