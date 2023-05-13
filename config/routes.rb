Rails.application.routes.draw do
  
  post '/sign_in' => 'authentication#sign_in'
  
  post '/sign_up' => 'user#sign_up'
  
  get 'home' => 'home#index'
end
  