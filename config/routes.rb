Rails.application.routes.draw do
  resources :quotes
  root 'static_pages#home'
  post "sign_up", to: "users#create"
  get "sign_up", to: "users#new"
  put "account", to: "users#update"
  get "account", to: "users#edit"
  resources :confirmations, only: [:create, :edit, :new], param: :confirmation_token  
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "logout", to: "sessions#destroy"
  get "login", to: "sessions#new"
  resources :passwords, only: [:create, :update, :edit, :new], param: :password_reset_token
end
