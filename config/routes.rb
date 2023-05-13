Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      post '/sign_in' => 'authentication#sign_in'
  
      post '/sign_up' => 'user#sign_up'
      
      get 'home' => 'home#index'
    end
  end


end
  