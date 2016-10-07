require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web, at:'/sidekiq'
  root 'matches#index'

  resources :matches

  resources :users, only: :create
  get 'sign_up', to: 'users#new', as: 'sign_up'

  resources :sessions, only: :create
  get 'log_in', to: 'sessions#new', as: 'log_in'
  delete 'log_out', to: 'sessions#destroy', as: 'log_out'

  resources :tournaments do
    resources :teams, only: [:new, :create, :update, :destroy] do
      delete 'remove_user/:user_id', to: 'teams#remove_user', as: 'remove_user'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
