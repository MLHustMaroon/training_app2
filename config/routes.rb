Rails.application.routes.draw do

  get 'errors/not_found'

  get 'errors/internal_server_error'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :tasks do
    get :autocomplete_tag_label, :on => :collection
  end
  resources :users
  post '/tasks', to: 'tasks#index'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
  root 'static_pages#home'
  namespace :admin do
    resources :users
    resources :tasks, only: [:index, :destroy]
    post '/tasks', to: 'tasks#index'
  end
end
