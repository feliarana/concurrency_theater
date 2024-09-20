Rails.application.routes.draw do
  devise_for :users, controllers: { session_controller: "user/sessions" }
  resources :performances, only: [ :index, :show ]
  resources :tickets, only: [ :index, :create, :update, :destroy ]
  resources :transactions, only: [ :create ]
end
