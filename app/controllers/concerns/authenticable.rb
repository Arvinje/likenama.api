module Authenticable

  # Devise methods overwrites
  def current_user
    @current_user ||= User.find_by(auth_token: request.headers['Authorization'])
  end

  def authenticate_with_token!
    not_found_error = { base: ["ارتباط با سرور قطع شده‌است. دوباره وارد شوید"] }
    locked_error = { base: ["اکانت شما قفل شده‌است. برای اطلاعات بیشتر با پشتیبانی تماس بگیرید"] }
    # When user is not found
    if !current_user.present?
      render json: { errors: not_found_error }, status: :unauthorized
    # When user is locked
    elsif !current_user.active_for_authentication?
      render json: { errors: locked_error }, status: :unauthorized
    end
  end

  def user_signed_in?
    current_user.present?
  end

end
