Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      post '/sign_in' => 'authentication#sign_in'
  
      post '/sign_up' => 'user#sign_up'
      
      get 'home' => 'home#index'
      get 'artists' => 'artists#index'

      resources :commissions, only: [:index, :create, :update, :show]
      resources :requests, only: [:index, :create, :update, :show]
      patch '/requests' => 'requests#update_payment'
      patch '/requests/:id/:status' => 'requests#cancel'
    end
  end


end
  