class Users::OmniauthCallbacksController < ApplicationController
  def instagram
    if request.env["HTTP_USER_AGENT"].include? "Likenama"
      user = User.from_omniauth(request.env["omniauth.auth"])
      if user.persisted?
        user.generate_authentication_token!
        user.save
        instagram_access_token = request.env["omniauth.auth"].credentials.token
        redirect_to session_path(anchor: "token=#{user.uid}#{instagram_access_token}")
      else
        redirect_to anchor: "error"
      end
    else
      user = User.find_omniauth_user(request.env["omniauth.auth"])
      unless user.nil?
        sign_in user
        redirect_to dashboard_path
      else
        redirect_to new_user_session_path
      end
    end
  end

  def failure
  end
end
