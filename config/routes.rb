Blog::Application.routes.draw do
  mount RedisDictionary::Engine => '/translations'
  # apipie
  # mount ApiTaster::Engine => "/api_taster" if Rails.env.development?
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'  

  namespace :api, defaults: { format: "json"} do
    
    namespace :v1 do
      resources :articles
    end

    namespace :v2 do
      resources :articles
    end

  end

  resources :products

  root to: 'articles#index'
  resources :static_pages
  resources :users
  resources :sessions
  resources :password_resets
  resources :articles
end
