Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants/search#index'
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], to: 'merchants/items#index'
      end

      get '/items/find_all', to: 'items/search#index'
      resources :items, only: [:index, :show, :create, :update, :destroy] do
        get '/merchant', to: 'items/merchants#show'
      end
    end
  end
end
