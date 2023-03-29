Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], to: 'merchants/items#index'

        
      end
      resources :items, only: [:index, :show, :create, :update, :destroy] do
        get '/merchant', to: 'items/merchants#show'
      end
    end
  end
end
