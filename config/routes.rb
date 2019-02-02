Rails.application.routes.draw do
  devise_for :users
  require 'api_constraints'

  namespace :api, defaults: { format: :json} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: [:show, :create, :update, :destroy]
      resources :sessions, only: [:create, :destroy]
    end
  end
end
