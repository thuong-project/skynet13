Rails.application.routes.draw do
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', password: 'password', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'sign_up' },
                       controllers: { omniauth_callbacks: 'omniauth_callbacks' }, skip: :omniauth_callbacks

    
    root 'users#home'

    devise_scope :user do
      get 'register', to: 'devise/registrations#new', as: :sign_up
    end

    resources :posts
    resources :users
    get "/search", to: 'users#search'
  end

  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', password: 'password', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'sign_up' },
                     controllers: { omniauth_callbacks: 'omniauth_callbacks' },
                     only: :omniauth_callbacks
  
end
