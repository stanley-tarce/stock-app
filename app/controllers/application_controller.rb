# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken


  private
  def authenticate_if_admin!
    current_api_v1_user.user_type == 'admin'
  end
  def authenticate_trader_status!
    current_api_v1_user.trader.status == 'approved'
  end


end
