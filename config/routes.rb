Rails.application.routes.draw do
  root 'static_pages#home'
  post "sign_up", to: "users#create"
  get "sign_up", to: "users#new"
  resources :confirmations, only: [:create, :edit, :new], param: :confirmation_token
  
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
