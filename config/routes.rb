Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'courses#index'
  get '/welcome', to: 'welcome#index'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users do
    resources :courses, only: %i(new edit create update destroy) 
  end
  resources :courses, only: %i(index show)
  resources :categories do
    member do
      get 'add_courses'
      patch 'update_courses'
    end
  end
end
