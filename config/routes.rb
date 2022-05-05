Rails.application.routes.draw do
  devise_for :users, controllers: { session: "users/registrations", sign_up:"users/registrations" }
  root 'welcome#index'
  resources :products
  resources :shopping_cart, only: [:index]
  resources :cart_products, only: %i( new create destroy )
  resources :users, only: [:show] do
    resources :addresses, only: %i( new edit create update destroy )
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
