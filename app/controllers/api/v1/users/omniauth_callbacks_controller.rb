class Api::V1::Users::OmniauthCallbacksController < ApplicationController
  def instagram
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user.persisted?
      user.generate_authentication_token!
      user.save
      redirect_to "SOMETHING"
    else
      redirect_to "http://localhost:3000/api/users/auth/#error"
    end
  end

  def failure
    redirect_to "http://localhost:3000/api/users/auth/#error"
  end
end
