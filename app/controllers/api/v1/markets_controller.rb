# frozen_string_literal: true

require "#{Rails.root}/app/controllers/modules/markets_module"

module Api
  module V1
    class MarketsController < ApplicationController
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

      def update_global_stocks
        if authenticate_if_admin!
          stocks = %w[AAPL TSLA NKE ACN UL UBER AMZN AUDVF AMD MSFT PXLW ADBE VZ
                      CAJFF NINOF FUJIF SONY MBFJF TOYOF PHG CSIOF YAMHF KO PEP CAT TWTR NVDA WACMF H COST DELL GDDY SEKEF STNE BA DIS HD SBUX GME ADDDF TGT UA SSNLF INTC WYNN LVS DISCA QCOM BABAF]
          client = IEX::Api::Client.new(
            publishable_token: ENV['IEX_PUBLISHABLE_TOKEN'],
            secret_token: ENV['IEX_SECRET_TOKEN'],  
            endpoint: 'https://cloud.iexapis.com/v1'
          )
          stocks.each do |stock|
            market = Market.find_by(symbol: stock)
            if market.nil?
              market = Market.new(symbol: stock)
              market.save
            else
              quote = client.quote(stock)
              market.update(price_per_unit: quote.latest_price, percentage_change: quote.change_percent_s)
            end
          end
          Stocks.all.each do |stock|
            specific_market = Market.find(stock.market_id)
            stock.update(price_per_unit: specific_market.price_per_unit,
                         percentage_change: specific_market.percentage_change)
          end
          render json: { message: 'Global stocks updated successfully' }, status: 200
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
  end
end
