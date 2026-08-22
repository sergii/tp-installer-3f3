# frozen_string_literal: true

Rails.application.routes.draw do
  get  "sign_in", to: "sessions#new", as: :sign_in
  post "sign_in", to: "sessions#create"
  get  "sign_up", to: "users#new", as: :sign_up
  post "sign_up", to: "users#create"

  resources :sessions, only: [ :destroy ]
  resource :users, only: [ :destroy ]

  namespace :identity do
    resource :email_verification, only: [ :show, :create ]
    resource :password_reset, only: [ :new, :edit, :create, :update ]
  end

  get :dashboard, to: "dashboard#index"
  get :today, to: "today#index"
  resources :projects, only: %i[index create show] do
    resources :tasks, only: :create
  end
  resources :tasks, only: :update
  get :knowledge, to: "knowledge#index"

  namespace :settings do
    resource :profile, only: [ :show, :update ]
    resource :password, only: [ :show, :update ]
    resource :email, only: [ :show, :update ]
    resources :sessions, only: [ :index ]
    inertia :appearance
  end

  root "home#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
