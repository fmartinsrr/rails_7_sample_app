Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "welcome#index"

  resources :users #, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  
  resources :articles do
    collection do 
      get :live
    end
  end

  get 'live_articles', to: 'articles#live'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  post 'logout', to: 'sessions#destroy'
  
end
