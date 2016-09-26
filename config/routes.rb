Rails.application.routes.draw do
  root 'matches#index'

  resources :matches

  resources :users, only: :create
  get 'sign_up', to: 'users#new', as: 'sign_up'

  resources :sessions, only: :create
  get 'log_in', to: 'sessions#new', as: 'log_in'
  delete 'log_out', to: 'sessions#destroy', as: 'log_out'

  resources :tournaments do
    post 'add_user', to: 'tournaments#add_user', as: 'add_user'
    delete 'remove_user/:user_id', to: 'tournaments#remove_user', as: 'remove_user'
    get 'team', to: 'tournaments#team', as: 'team'
    post 'add_team', to: 'tournaments#add_team', as: 'add_team'
  end

  resources :teams
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
