Rails.application.routes.draw do
  resources :performances, only: [ :index, :show ]
  resources :tickets, only: [ :create, :update, :destroy ]
  resources :users, only: [ :create ]
  resources :transactions, only: [ :create ]
end
