# frozen_string_literal: true

require "#{Rails.root}/app/controllers/modules/stocks_module"
require "#{Rails.root}/app/controllers/modules/transaction_histories_module"

module Api
  module V1
    class StocksController < ApplicationController
      before_action :authenticate_api_v1_user!
      include StocksModule
      def index
        if !authenticate_if_admin! && authenticate_trader_status!
          render json: stock_all_v2
        else
          render json: { error: 'You are not authorized to perform this action.' }, status: :unauthorized
        end
      end

      def create
        if !authenticate_if_admin! && authenticate_trader_status!
          return render json: { error: 'Stock Existing Already' }, status: 422 if check_existing_stock

          trader = current_api_v1_user.trader
          market = Market.find(params[:stock][:market_id])
          stock = trader.stocks.new(stock_params)
          stock.stock_name = market.stock_name
          stock.price_per_unit = market.price_per_unit
          stock.total_price = market.price_per_unit * params[:stock][:shares].to_i
          stock.symbol = market.symbol
          stock.logo = market.logo
          if (trader.wallet < stock.total_price) || trader.wallet.zero? || params[:stock][:shares].to_i <= 0
            return render json: { error: 'Insufficient Funds' }, status: 422
          else
            trader.update(wallet: trader.wallet - stock.total_price)
          end

          transaction = trader.transaction_histories.new(shares: params[:stock][:shares], total_shares: params[:stock][:shares],
                                                         price_per_unit: market.price_per_unit, total_price: stock.total_price, trader: trader, stock_name: market.stock_name, balance: trader.wallet, transaction_type: 'buy', symbol: market.symbol)

          if stock.save && transaction.save
            render json: transaction, status: 200
          else
            render json: { errors: 'Stock creation failed' }, status: 422
          end
        else
          render json: { error: 'You are not authorized to create a stock' }, status: :unauthorized
        end
      end

      def buy_update
        if !authenticate_if_admin! && authenticate_trader_status!
          trader = current_api_v1_user.trader
          old_stock_shares = single_stock.shares
          market = Market.find(single_stock.market_id)
          buy_value = single_stock.price_per_unit * params[:shares].to_i

          if trader.wallet < buy_value || trader.wallet.zero? || params[:shares].to_i <= 0
            return render json: { error: 'Insufficient Funds' }, status: 422
          else
            trader.update(wallet: trader.wallet - buy_value)
          end

          new_stock_shares = old_stock_shares + params[:shares].to_i

          new_total_price = new_stock_shares * single_stock.price_per_unit
          if single_stock.update(shares: new_stock_shares, total_price: new_total_price)
            transaction = trader.transaction_histories.new(shares: params[:shares], total_shares: new_stock_shares, price_per_unit: market.price_per_unit,
                                                           total_price: single_stock.total_price, trader: trader, stock_name: market.stock_name, balance: trader.wallet, transaction_type: 'buy', symbol: market.symbol)
            if transaction.save
              render json: trader.transaction_histories.all, status: 200
            else
              render json: { errors: 'Stock update failed1' }, status: 422
            end
          else
            render json: { errors: 'Stock update failed2' }, status: 422
          end
        else
          render json: { error: 'You are not authorized to update a stock' }, status: :unauthorized
        end
      end

      def sell_update
        if !authenticate_if_admin! && authenticate_trader_status!
          trader = current_api_v1_user.trader
          old_stock_shares = single_stock.shares
          market = Market.find(single_stock.market_id)
          new_stock_shares = old_stock_shares - params[:shares].to_i
          new_wallet = single_stock.price_per_unit * params[:shares].to_i
          return render json: { error: 'Insufficient Shares' }, status: 422 if new_stock_shares.negative?

          trader.update(wallet: trader.wallet + new_wallet)
          if new_stock_shares.zero?
            transaction = trader.transaction_histories.create(shares: params[:shares], total_shares: new_stock_shares, price_per_unit: market.price_per_unit,
                                                              total_price: single_stock.total_price, trader: trader, stock_name: market.stock_name, symbol: market.symbol, balance: trader.wallet, transaction_type: 'sell')
            single_stock.destroy
            return render json: { message: 'Stocks Deleted' }, status: 200
          end
          if single_stock.update(shares: new_stock_shares, total_price: new_stock_shares * single_stock.price_per_unit)
            transaction = trader.transaction_histories.new(shares: params[:shares], total_shares: new_stock_shares, price_per_unit: market.price_per_unit,
                                                           total_price: params[:shares].to_i * single_stock.price_per_unit, trader: trader, stock_name: market.stock_name, symbol: market.symbol, balance: trader.wallet, transaction_type: 'sell')
            if transaction.save
              render json: trader.transaction_histories.all, status: 200
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

      def show
        render json: single_stock
      end

      private

      def stock_all
        @stocks = []
        Stock.all.each do |stock|
          @stocks << stock if stock.trader_id == current_api_v1_user.trader.id
        end
        @stocks
      end

      def stock_all_v2
        Stock.where(trader_id: current_api_v1_user.trader.id)
      end

      def single_stock
        Trader.find_by(id: params[:trader_id]).stocks.find(params[:id])
      end

      def check_existing_stock
        if current_api_v1_user.trader.stocks.all.length.positive?
          current_api_v1_user.trader.stocks.all.each do |stock|
            return true if stock.market_id == params[:stock][:market_id]
          end
        else
          return false
        end
        false
      end
    end
  end
end
