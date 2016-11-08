require 'sidekiq/web'

Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  mount Sidekiq::Web, at:'/sidekiq'
  root 'matches#index'

  namespace :api do
    namespace :v1 do
      resources :matches, only: [:index, :create, :update, :destroy]

      resources :users, only: [:index, :create]

      resources :tournaments, only: [:index, :create, :update, :destroy] do
        resources :teams, only: [:create, :update, :destroy] do
          delete 'remove_user/:user_id', to: 'teams#remove_user', as: 'remove_user'
        end
      end
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
