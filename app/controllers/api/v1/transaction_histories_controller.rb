module Api
  module V1
    class TransactionHistoriesController < ApplicationController
      before_action :authenticate_api_v1_user!
      def index
        trader = current_api_v1_user.trader
        render json: trader.transaction_histories, status: :ok
      end
      def show
        trader = current_api_v1_user.trader
        render json: trader.transaction_histories.find_by(id: params[:id]), status: :ok
      end
      private 
      def find_transaction_history
        Trader.find(params[:id]).transaction_histories
      end
      def find_single_transaction_history
        Trader.find(params[:id]).transaction_histories.find_by(id: params[:id])
      end
    end
  end
end