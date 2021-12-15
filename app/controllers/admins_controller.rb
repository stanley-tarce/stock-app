class AdminController < ApplicationController
  before_action :authenticate_admin!, only: [:create_user]
  def index
    @admin = Admin.all
    render json: @admin, status: 200
  end

  def create_user 
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :ok 
    else
     render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  private 
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
