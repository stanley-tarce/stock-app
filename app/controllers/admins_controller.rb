class AdminController < ApplicationController

  def index
    render json: admins, status: 200
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
    params.require(:admin).permit(:email, :password, :password_confirmation)
  end
end
