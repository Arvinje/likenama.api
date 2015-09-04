class Api::V1::Users::OmniauthCallbacksController < ApplicationController
  def instagram
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user.persisted?
      user.generate_authentication_token!
      user.save
      instagram_access_token = request.env["omniauth.auth"].credentials.token
      redirect_to anchor: "access_token=#{instagram_access_token}&uid=#{user.uid}"
    else
      redirect_to anchor: "error"
    end
  end

  def failure
  end
end
