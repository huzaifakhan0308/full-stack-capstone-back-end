Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index, :show, :create, :update, :destroy] do
    resources :rooms, only: [:index, :show, :create, :destroy]
    resources :reservations, only: [:index, :create, :destroy]
  end
end
