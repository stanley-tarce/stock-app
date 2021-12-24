require "#{Rails.root}/app/controllers/modules/markets_module"

class Api::V1::MarketsController < ApplicationController
  before_action :authenticate_api_v1_user!
  include MarketsModule
  def index
      render json: market_all
  end
  def show
      render json: market_single
  end
  def create 
    if authenticate_if_admin!
      market = Market.new(market_params)
      if market.save
        render json: market, status: 200
      else
        render json: { errors: 'Market creation failed' }, status: 422
      end
    else
      render json: { error: 'You are not authorized to view this page.' }, status: 401
    end
  end
  def update
    if authenticate_if_admin!
      if market_single.update(market_params)
        render json: { message: 'Market updated successfully' }, status: 200
      else
        render json: { error: 'Market update failed' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'You are not authorized to view this page.' }, status: 401
    end
  end
  def destroy
    if authenticate_if_admin!
      if market_single.destroy
        render json: { message: 'Market deleted successfully' }, status: 200
      else
        render json: { error: 'Market deletion failed' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'You are not authorized to view this page.' }, status: 401
    end
  end


  private
  def market_all
    Market.all 
  end
  def market_single
    Market.find_by(id: params[:id])
  end
end

