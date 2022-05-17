Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'
  resources :products
  resources :shopping_cart, only: [:index]
  resources :cart_products
  resources :orders, only: %i( new edit create index show update)
  resources :cart_products, only: %i( new create update destroy )
  resources :users, only: [:show] do
    resources :addresses, only: %i( new edit create update destroy )
  end
  
end
