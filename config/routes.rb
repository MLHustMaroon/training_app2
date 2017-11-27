Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :tasks do
    get :autocomplete_tag_label, :on => :collection
  end
  resources :users
  post '/task_filter', to: 'tasks#filter'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  root 'static_pages#home'
  namespace :admin do
    resources :users
    resources :tasks, only: [:index, :destroy]
  end
end
