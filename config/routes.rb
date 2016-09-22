Rails.application.routes.draw do
  root 'matches#index'

  resources :matches

  resources :users, only: :create
  get 'sign_up', to: 'users#new', as: 'sign_up'

  resources :sessions, only: :create
  get 'log_in', to: 'sessions#new', as: 'log_in'
  delete 'log_out', to: 'sessions#destroy', as: 'log_out'

  resources :tournaments
  post 'tournaments/:id/add_user', to: 'tournaments#add_user', as: 'add_user'
  delete 'tournaments/:id/remove_user/:user_id', to: 'tournaments#remove_user', as: 'remove_user'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
