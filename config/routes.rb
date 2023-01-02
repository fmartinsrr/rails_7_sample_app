Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "welcome#index"

  resources :users #, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  resources :articles

  get 'live_articles', to: 'articles#live'
end
