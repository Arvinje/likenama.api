require 'api_constraints'

Rails.application.routes.draw do
  #devise_for :users
  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      devise_for :users, :controllers => { :omniauth_callbacks => "api/v1/users/omniauth_callbacks" }
      resources :campaigns, only: [:index, :create, :show]
    end
  end
end
