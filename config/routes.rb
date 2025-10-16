Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  if Rails.env.development? || Rails.env.test?
    mount MissionControl::Jobs::Engine, at: '/jobs'

    resources :code_qualities, only: :index

    # Wildcard route for show to capture nested folders
    get 'code_qualities/*filename', to: 'code_qualities#show', as: 'code_quality'
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the landing page route
  root 'pages#home'

  # Sessions
  resource :registration, only: %i[new create]
  resource :session, only: %i[new create destroy]
  resources :passwords, param: :token, except: %i[index show destroy]

  resource :dashboard, only: :show

  resources :collections do
    resources :documents, except: :index
  end

  get 'search', to: 'search#index', as: :search

  resources :user_integrations, only: :index do
    member do
      get :ai_connect
      patch :update_ai

      # get :cloud_connect
      delete :disconnect
    end

    # collection do
    #   get :oauth_callback  # For cloud provider OAuth callback
    # end
  end
end
