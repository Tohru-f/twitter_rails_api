# frozen_string_literal: true

Rails.application.routes.draw do
  resources :tasks
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'users', controllers: {
        registrations: 'api/v1/registrations',
        omniauth_callbacks: 'api/v1/omniauth_callbacks'
      }
      resources :sessions, only: %i[index]
      resources :tweets, only: %i[create index show]
      resources :images, only: %i[create]
    end
  end
end
