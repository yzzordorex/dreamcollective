Rails.application.routes.draw do
  get 'home/index'

  get 'sessions/new'
  
  resources :sessions
  resources :users

  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'verify/:token', to: 'users#verify', as: 'verify'
  get 'profile', to: 'users#show', as: 'profile'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  root :to => 'home#index'
end
