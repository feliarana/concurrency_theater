Rails.application.routes.draw do
  devise_for :users, path: "", path_names: {
    sign_in: "login",
    sign_out: "logout",
    registration: "signup"
  },
  controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  resources :performances, only: [ :index, :show ]
  resources :transactions, only: [ :create ]
  resources :tickets, only: [ :index, :create ] do
    collection do
      post "reset", to: "tickets#reset"
    end
    member do
      post "reserve", to: "tickets#reserve"
      post "purchase", to: "tickets#purchase"
      post "cancel", to: "tickets#cancel"
    end
  end
end
