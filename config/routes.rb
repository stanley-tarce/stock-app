# frozen_string_literal: true

Rails.application.routes.draw do
  # resources :traders, only: [:index]
  # get 'trader/show_trader_stocks', to: 'trader#show_trader_stocks'
  # get 'trader/change_trader_status', to: 'trader#change_trader_status'

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: { sessions: 
        'api/v1/overrides/sessions' }
      post '/admins/create_trader', to: 'admins#create_trader' # @leandrajade @miyutogo I think this is a bit redundant because we already have a route/method for this. traders#create
      resources :admins do
        get 'update_global_stocks', to: 'markets#update_global_stocks'
      end
      get 'traders/updatestatus/:id', to: 'traders#update_trader_status'
      get 'traders/rejectstatus/:id', to: 'traders#reject_trader_status'
      get 'traders/show_trader_data', to: 'traders#show_trader_data'
      get 'traders/transaction_histories', to: 'transaction_histories#index'
      get 'traders/transaction_histories/:id', to: 'transaction_histories#show'
      resources :traders do
        get '/show_trader_data', to: 'traders#show_trader_data'
        resources :stocks
        patch 'buy/stocks/:id', to: 'stocks#buy_update'
        patch 'sell/stocks/:id', to: 'stocks#sell_update'
        patch 'cash_in', to: 'traders#cash_in'
        patch 'cash_out', to: 'traders#cash_out'
      end
      resources :markets
    end
  end
end
