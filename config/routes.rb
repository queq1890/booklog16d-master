Rails.application.routes.draw do

  devise_for :users
  root 'top#index'

  resources :users, only: [:show, :edit, :update] do
    member do
      get 'profile'
    end
  end
  resources :top, only: [:index]

  resources :items, only: :show do
    resources :reviews, only: [:edit, :update]
    collection do
      get 'search'
    end
  end

  resources :bookmarks, only: :create
end
