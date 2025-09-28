# frozen_string_literal: true

Rails.application.routes.draw do
  resources :tasks
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  namespace :api do
    namespace :v1 do
      get 'login_users' => 'login_users#show'
      put 'login_users' => 'login_users#update'
      get 'tweets/:id/comments' => 'comments#index'
      post 'tweets/:id/retweets' => 'retweets#create'
      delete 'tweets/:id/retweets' => 'retweets#destroy'
      post 'tweets/:id/favorites' => 'favorites#create'
      delete 'tweets/:id/favorites' => 'favorites#destroy'
      post 'users/:id/follow' => 'users#create'
      delete 'users/:id/unfollow' => 'users#destroy'
      get 'users/search' => 'users#search'
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/registrations',
        omniauth_callbacks: 'api/v1/omniauth_callbacks'
      }
      resources :sessions, only: %i[index]
      resources :tweets, only: %i[create index show destroy]
      resources :images, only: %i[create]
      resources :users, only: %i[show]
      resources :comments, only: %i[create destroy]
      resources :notifications, only: %i[index]
      resources :groups, only: %i[create index] do
        resources :messages, only: %i[index create]
      end
    end
  end
end
