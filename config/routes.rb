require 'api_constraints'

Rails.application.routes.draw do
  #devise_for :users
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      devise_for :users, :controllers => { :omniauth_callbacks => "api/v1/users/omniauth_callbacks" }, :skip => [:sessions, :passwords, :registrations]
    end
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      get 'users/self' => 'users#self'
      resources :sessions, only: [:create]
      resources :campaigns, only: [:index, :new, :create, :show, :update] do
        resource :like, only: [:create]
      end
      get 'campaigns/next' => 'campaigns#next'
      resources :products, only: [:index] do
        resource :purchase, only: [:create]
      end
    end
  end
end
