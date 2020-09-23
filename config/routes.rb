# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    root '/newsfeed'

    resources :users do
      get 'search', action: :search, on: :collection
      resources :posts
      scope controller: 'follows' do
        get 'following'
        get 'followers'
        post 'follow'
      end
    end
    
    scope 'posts/:post_id' do
      resources :likes, only: [:index, :create, :destroy]
      resources :comments
    end

    # 
    get 'newsfeed', to: 'users#newsfeed'
    get 'conversation', to: 'conversations#show'
    post 'conversation', to: 'conversations#create_message'

    # custom change password
    devise_scope :user do
      get 'password/change', to: 'authen/registrations#get_change_password',
          as:'change_password' 
      post 'password/change', to: 'authen/registrations#post_change_password'
    end

    # devise 
    devise_for :users, path: '', path_names: { sign_in: 'login', 
      sign_out: 'logout', password: 'password',
      confirmation: 'verification', unlock: 'unblock', 
      registration: 'register', sign_up: 'sign_up' },
      controllers: { registrations: 'authen/registrations',
                    sessions: 'authen/sessions' }, 
      skip: :omniauth_callbacks
  end

  # omniauth dont support i18n
  devise_for :users, skip: %i[session password registration], 
              controllers: { omniauth_callbacks: 'authen/omniauth_callbacks' }
end
