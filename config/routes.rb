Rails.application.routes.draw do
  root 'welcome#index'
  resources :products
  resources :shopping_cart, only: [:index]
  resources :cart_products
  resources :orders, only: %i( new create show index)
  get 'sign_up', to: 'registrations#new'
  post 'sign_up', to: 'registrations#create'
  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create', as: 'log_in'
  delete 'logout', to: 'sessions#destroy'
  resources :users, only: [:show] do
    resources :addresses, only: %i( new edit create update destroy )
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
