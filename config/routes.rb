Rails.application.routes.draw do
  resources :convert, only: [:index, :show], param: :isbn
  resources :book, only: [:index, :show], param: :isbn

  # Defines the root path route ("/")
  root "api#index"
end
