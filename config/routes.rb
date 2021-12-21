Rails.application.routes.draw do
  
  # resources :traders, only: [:index]
  # get 'trader/show_trader_stocks', to: 'trader#show_trader_stocks'
  # get 'trader/change_trader_status', to: 'trader#change_trader_status'

  namespace :api do 
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
      post '/admins/create_trader', to: 'admins#create_trader' # @leandrajade @miyutogo I think this is a bit redundant because we already have a route/method for this. traders#create
      resource :admins
      get 'traders/updatestatus/:id', to: 'traders#update_trader_status'
      resources :traders do
        resource :stocks
      end
      resource :markets
      
    end
  end 
  # as :admin do
  #   # Define routes for Admin within this block.
  #   # get '/articles/:id/edit' => 'articles#edit', as: 'edit_article'
  #   # post '/articles/:id' => 'articles#update', as: 'update_article'
  #   get 'admin/list_users' => 'admin#list_users', as: 'list_users'
  #   patch 'admin/update_user/:id' => 'admin#update_user', as: 'update_user'
  #   post 'admin/create_user' => 'admin#create_user',  as: 'create_user'
  #   get 'admin/show_user/:id' => 'admin#show_user', as: 'show_user' 
  # end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
