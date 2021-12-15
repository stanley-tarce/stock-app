Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  mount_devise_token_auth_for 'Admin', at: 'admin_auth'
  as :admin do
    # Define routes for Admin within this block.

    post 'admin/create_user' => 'admin#create_user',  as: 'create_user'

  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
