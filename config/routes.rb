Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      post '/sign_in' => 'authentication#sign_in'
  
      post '/sign_up' => 'user#sign_up'
      
      get 'home' => 'home#index'
      get 'artists' => 'artists#index'

      resources :commissions, only: [:index, :create, :update, :show]
      patch '/commissions/:id/process' => 'commissions#update_process'
      
      resources :requests, only: [:index, :create, :update, :show]
      patch '/requests/:id/:payment_status' => 'requests#update_payment'
      patch '/requests/:id/:status/edit' => 'requests#cancel'
     
    end
  end


end
  