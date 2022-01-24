Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  match '/users/auth/imgur/callback', to: 'users/omniauth_callbacks#imgur', via: [:get, :post]

  get '/privacy-policy', to: 'privacy_policy#index'
  root 'homepage#index'

  resource :onboarding, only: [:new, :create] do
    get '/', to: 'onboardings#new'
  end

  resources :accounts, except: [:show] do
    put 'birthday', on: :collection
    put 'country', on: :collection
  end

  get '/cuenta', to: 'accounts#edit'
  get '/reclutamiento', to: 'static#reclutamiento'
  get '/rewards', to: 'static#rewards'

  resources :albums, only: [:index, :show]
  resources :speak do
    collection do
      post 'reject'
    end
  end

  namespace :streamers do
    root 'twitch_auth#index'
    resources :twitch_auth, only: :index do
      get :flow, on: :collection
    end
    resources :mods, only: [:create, :destroy] do
      collection do
        post 'play',    to: 'tts_actions#play'
        post 'mute',    to: 'tts_actions#mute'
        post 'unmute',  to: 'tts_actions#unmute'
        post 'stop',    to: 'tts_actions#stop'
        post 'refresh', to: 'tts_actions#refresh'
      end
    end
    resources :quick_votes, only: [:show, :create, :update]
    resources :dashboard
    resources :competencias, only: [:show, :destroy]
  end

  resources :tts

  namespace :widgets do
    resources :tts
    resources :quick_votes, only: :show
  end

  namespace :api do
    resources :sessions
    resources :recruitments
    resources :tts do
      collection do
        get 'chiste'
      end
    end
    resources :quick_votes
  end

  namespace :admin  do
    resources :albums do
      get 'sync'
      get 'toggle_publish'
    end
  end
end
