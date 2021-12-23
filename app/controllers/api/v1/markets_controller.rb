require "#{Rails.root}/app/controllers/modules/market_module"

class Api::V1::MarketsController < ApplicationController
  before_action [:authenticate_api_v1_user!, :authenticate_api_v1_admin!]
  include MarketsModule
  def index
    if authenticate_if_admin!
      render json: market_all
    else
      render json: { error: 'You are not authorized to view this page.' }, status: 401
    end
  end
  def show
    if authenticate_if_admin!
      render json: market_single
    else
      render json: { error: 'You are not authorized to view this page.' }, status: 401
    end
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
  def delete
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

