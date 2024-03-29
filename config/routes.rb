# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static_pages#home'

  get 'signup', to: 'users#new'
  get 'help', to: 'static_pages#help'
  get 'about', to: 'static_pages#about'
  get 'contact', to: 'static_pages#contact'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users do
    member do
      get :following, :followers
    end
  end

  resource :user, only: [] do
    member do
      get :confirm
    end
  end

  resources :account_activations, only: [:edit]
  resources :password_resets, only: %i[new create edit update]
  resources :microposts, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]
end
