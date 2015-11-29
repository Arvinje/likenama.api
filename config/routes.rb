require 'api_constraints'

Rails.application.routes.draw do

  resource :management, only: [:show] do
    resources :campaigns, only: [:index, :show], controller: 'managements/campaigns'
  end
#============================ Dashboard ROUTES =======================#
  resource :dashboard, only: [:show] do
    resources :bundles, only: [:index], controller: 'dashboards/bundles' do
      resource :purchase, only: [:create, :show], controller: 'dashboards/bundles/purchases' do
        member do
          get :callback
        end
      end
    end
  end
#============================ USERS ROUTES ============================#
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }, :skip => [:sessions, :passwords, :registrations]
  devise_scope :user do
    get "/login" => "sessions#new", :as => :new_user_session
  end
  resource :session, only: [:show]
#============================ API ROUTES ===============================#
  namespace :api, defaults: { format: :json } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: [:index] do
        collection do
          get :self
        end
      end
      resources :sessions, only: [:create]
      resources :campaigns, only: [:index, :new, :create, :show, :update] do
        resource :like, only: [:create], controller: 'campaigns/likes'
        collection do
          get :next
        end
      end
      resources :products, only: [:index] do
        resource :purchase, only: [:create], controller: 'products/purchases'
      end
    end
  end
end
