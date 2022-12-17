Rails.application.routes.draw do
  resources :books, param: :isbn

  # Defines the root path route ("/")
  # root "articles#index"
end
