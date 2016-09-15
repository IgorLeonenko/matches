Rails.application.routes.draw do
  root 'users#new'

  get 'sign_up' => 'users#new', as: 'sign_up'
  get 'log_in'  => 'sessions#new', as: 'log_in'
  delete 'log_out' => 'sessions#destroy', as: 'log_out'

  resources :matches
  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
