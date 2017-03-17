Rails.application.routes.draw do
  resources :dreams
  get 'home/index'

  get 'sessions/new'
  
  resources :sessions
  resources :users

  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'verify/:token', to: 'users#verify', as: 'verify'

  get 'settings', to: 'users#show', as: 'settings'
  get 'settings/edit', to: 'users#edit', as: 'edit_settings'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  root :to => 'home#index'
end
