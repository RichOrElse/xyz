Rails.application.routes.draw do
  resources :convert, only: [:index, :show], param: :isbn
  resources :books, param: :isbn

  # Defines the root path route ("/")
  # root "articles#index"
end
