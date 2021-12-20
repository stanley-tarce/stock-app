require "#{Rails.root}/app/controllers/models/stock_module"
require "#{Rails.root}/app/controllers/models/transction_histories_module"

class Api::V1::StocksController < ApplicationController
  include StocksModule
  def index
    render json: stock_all
  end

  def create
    if !(authenticate_if_admin!)
      trader = current_api_v1_user.trader
      market = Market.find(params[:stock][:market_id])
      trader.stocks.new(stock_params)
      trader.stocks.stock_name = market.stock_name
      trader.stocks.price_per_unit = market.price_per_unit
      trader.stocks.total_price = market.price_per_unit * params[:stock][:shares].to_i
      if (trader.wallet < trader.stocks.total_price)
        return render json: { error: 'Insufficient Funds' }, status: 422 
      end
      transaction = trader.transaction_histories.new(shares: params[:stock][:shares],price_per_unit: market.price_per_unit,total_price: trader.stocks.total_price, trader: trader, stock_name: market.stock_name)
      if trader.stocks.save && transaction.save
        render json: trader.stocks, status: 200
      else
        render json: { errors: 'Stock creation failed' }, status: 422
      end
    else
      render json: { error: 'You are not authorized to create a stock' }, status: :unauthorized
    end
  end

  def update
  end

  def destroy
  end

  def show
  end
  private
  def stock_all
    stocks = []
    Stock.all each do |stock|
      if stock.trader_id == current_api_v1_user.trader.id
        @stocks << stock
      end
    end
    return stocks
  end
  def stock_all_v2
    Stock.where(trader_id: current_api_v1_user.trader.id)
  end
end
