# # frozen_string_literal: true

# class TradersController < ApplicationController
#   before_action :authenticate_user!
#   def index
#     if current_user.user_type == 'admin'
#       render json: Trader.all
#     else
#       render json: { error: 'You are not authorized to view this page.' }
#     end
#   end

#   def show_trader_stocks
#     if check_trader_status!
#       render json: { error: "Stanley wala ka pang stocks"}
#     else 
#       render json: { error: "You are not authorized to view this page." }
#     end
#   end

#   def change_trader_status
#     if current_user.user_type == 'admin'
#       Trader.first.update(status: "approved")
#       render json: { status: "approved", message: "Trader status changed to approved" }, status: 200
#     else
#       render json: { errors: "You are not authorized to view this page." }, status: :unauthorized
#     end
#   end 

#   private

#   def trader_params
#     params.require(:trader).permit(:name, :email)
#   end

#   def check_trader_status!
#     if current_user.user_type == 'trader'
#       trader = Trader.where(user_id: current_user.id)
#       if trader.first.status == 'approved'
#         return true
#       else
#         return false
#       end
#     else
#       return true
#     end
#   end
# end
