Rails.application.routes.draw do
  resources :examples
  root 'users#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.htmldevise_scope :user do
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', password: 'password', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'sign_up' },
  controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  
end
