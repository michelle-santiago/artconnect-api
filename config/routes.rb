Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      post '/sign_in' => 'authentication#sign_in'
  
      post '/sign_up' => 'user#sign_up'
      
      get 'home' => 'home#index'

      resources :artists, only: [:index, :show, :update]

      resources :commissions, only: [:index, :create, :update, :show]
      patch '/commissions/:id/add_process' => 'commissions#add_process'
      patch '/commissions/:id/update_process' => 'commissions#update_process'
      patch '/commissions/:id/complete_process' => 'commissions#complete_process'
      patch '/commissions/:id/complete_status' => 'commissions#complete_status'

      resources :requests, only: [:index, :create, :update, :show]
      patch '/requests/:id/:payment_status' => 'requests#update_payment'
      patch '/requests/:id/:status/edit' => 'requests#cancel'

      resources :messages, only: [:index, :create]
     
    end
  end
  
  mount ActionCable.server => '/cable'

end
  