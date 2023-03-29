Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index, :show]
      end
      resources :items, only: [:index, :show, :create, :update, :destroy] do
        get '/merchant', to: 'merchants#show'
      end
    end
  end
end
