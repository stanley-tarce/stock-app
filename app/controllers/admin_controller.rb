# class AdminController < ApplicationController
#   # before_action :authenticate_user!

#   def list_users
#     @users = User.all
#     render json: @users, status: :ok 
#   end
  
#   def create_user 
#     @user = User.new(user_params)

#     if @user.save
#       render json: @user, status: :ok 
#     else
#      render json: { errors: @user.errors.full_messages }, status: 422
#     end
#   end

    
#   def show_user
#     @user = User.find(params[:id])
#     render json: @user, status: 200
#   end

#   def update_user
#     @user = User.find(params[:id])

#     if @user.update(user_params)
#       render json: @user, status: 200
#     end
#   end


#   private 
#   def user_params
#     params.permit(:email, :password, :password_confirmation)
#   end
# end
