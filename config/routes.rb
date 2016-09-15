Rails.application.routes.draw do
  root 'users#new'

  get 'sign_up' => 'users#new', as: 'sign_up'

  resources :matches
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
