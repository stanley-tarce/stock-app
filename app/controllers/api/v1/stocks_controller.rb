require "#{Rails.root}/app/controllers/modules/stocks_module"
require "#{Rails.root}/app/controllers/modules/transaction_histories_module"

class Api::V1::StocksController < ApplicationController
  before_action :authenticate_api_v1_user!
  include StocksModule
  def index
    render json: stock_all
  end

  def create
    if !(authenticate_if_admin!) && authenticate_trader_status!
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

  def buy
    if !(authenticate_if_admin!) && authenticate_trader_status!
      trader = current_api_v1_user.trader
      old_stock_shares = single_stock.shares
      buy_value = single_stock.price_per_unit * params[:stock][:shares].to_i
      if (trader.wallet < buy_value)
        return render json: { error: 'Insufficient Funds' }, status: 422
      end
      new_stock_shares = old_stock_shares + params[:stock][:shares].to_i
      if single_stock.update(shares: new_stock_shares, total_price: new_stock_shares*single_stock.price_per_unit)
        transaction = trader.transaction_histories.new(shares: params[:stock][:shares],price_per_unit: market.price_per_unit,total_price: trader.stocks.total_price, trader: trader, stock_name: market.stock_name)
        if transaction.save 
          render json: trader.stocks, status: 200
        else
          render json: { errors: 'Stock update failed' }, status: 422
        end
      else
        render json: { errors: 'Stock update failed' }, status: 422
      end
    else
      render json: { error: 'You are not authorized to update a stock' }, status: :unauthorized     
    end
  end
  def sell
    if !(authenticate_if_admin!) && authenticate_trader_status!
      trader = current_api_v1_user.trader
      old_stock_shares = single_stock.shares
      new_stock_shares = old_stock_shares - params[:stock][:shares].to_i
      new_wallet = single_stock.price_per_unit * params[:stock][:shares].to_i
      trader.wallet = trader.wallet + new_wallet
      if new_stock_shares < 0
        single_stock.delete
        transaction = trader.transaction_histories.new(shares: params[:stock][:shares],price_per_unit: market.price_per_unit,total_price: trader.stocks.total_price, trader: trader, stock_name: market.stock_name)
        return render json: { message: "Stocks Deleted"}, status: 200
      end
      if single_stock.update(shares: new_stock_shares, total_price: new_stock_shares*single_stock.price_per_unit)
        transaction = trader.transaction_histories.new(shares: params[:stock][:shares],price_per_unit: market.price_per_unit,total_price: trader.stocks.total_price, trader: trader, stock_name: market.stock_name)
        if transaction.save 
          render json: trader.stocks, status: 200
        else
          render json: { errors: 'Stock update failed' }, status: 422
        end
      else
        render json: { errors: 'Stock update failed' }, status: 422
      end
    else
       #Continue here
       render json: { error: 'You are not authorized to update a stock' }, status: :unauthorized     
    end
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
  def single_stock
    Trader.stocks.find(params[:id])
  end
end
