Rails.application.routes.draw do
  
  # resources :traders, only: [:index]
  # get 'trader/show_trader_stocks', to: 'trader#show_trader_stocks'
  # get 'trader/change_trader_status', to: 'trader#change_trader_status'

  namespace :api do 
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
      post '/admins/create_trader', to: 'admins#create_trader' # @leandrajade @miyutogo I think this is a bit redundant because we already have a route/method for this. traders#create
      resources :admins
      get 'traders/updatestatus/:id', to: 'traders#update_trader_status'
      resources :traders do
        resources :stocks
      end
      resource :markets
    end
  end 
end
