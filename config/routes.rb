require 'api_constraints'
require 'sidekiq/web'

Rails.application.routes.draw do

  devise_for :managers, :skip => [:sessions, :registrations, :unlocks]
  devise_scope :manager do
    get '/management/login' => 'devise/sessions#new', :as => :new_manager_session
    post '/management/login' => 'devise/sessions#create', :as => :manager_session
    delete 'management/logout' => 'devise/sessions#destroy', :as => :destroy_manager_session
  end

  resource :management, only: [:show] do
    authenticate :manager do
      mount Sidekiq::Web => '/sidekiq'
    end
    resources :users, only: [:index, :show, :update], controller: 'managements/users' do
      member do
        patch :lock
        patch :unlock
      end
    end
    resources :campaigns, only: [:index, :show, :update], controller: 'managements/campaigns'
    resources :reports, only: [:index], controller: 'managements/reports' do
      member do
        patch :check
        patch :uncheck
      end
    end
    resources :messages, only: [:index, :show, :destroy], controller: 'managements/messages'
    resources :product_types, only: [:index, :new, :create, :edit, :update, :destroy], controller: 'managements/product_types'
    resources :products, controller: 'managements/products' do
      resources :product_details, controller: 'managements/products/product_details', only: [:create, :edit, :update]
    end
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
      resources :campaigns, only: [:index, :new, :create] do
        resource :like, only: [:create], controller: 'campaigns/likes'
        resource :report, only: [:create], controller: 'campaigns/reports'
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
