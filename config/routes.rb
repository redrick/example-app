Blog::Application.routes.draw do
  namespace :api, defaults: { format: "json"} do
    resources :products
    resources :articles
  end

  resources :products

  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'  
  root to: 'articles#index'
  resources :static_pages
  resources :users
  resources :sessions
  resources :password_resets
  resources :articles
end
