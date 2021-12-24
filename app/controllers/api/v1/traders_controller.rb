# frozen_string_literal: true
require "#{Rails.root}/app/controllers/modules/traders_module"
module Api
  module V1
    class TradersController < ApplicationController
      before_action :authenticate_api_v1_user!, except: [:create]
      include TradersModule
      def index
        if send(:authenticate_if_admin!)
          render json: all_trader
        else
          render json: { error: 'You are not authorized to view this page.' }, status: :unauthorized
        end
      end

      def create
        exceptions = %i[password password_confirmation]
        trader = Trader.new(trader_params.except(*exceptions))
        user = User.new(email: trader.email, password: params[:trader][:password],
                           password_confirmation: params[:trader] [:password_confirmation], name: params[:trader][:name], user_type: 'trader')
        if user.save 
          trader.user_id = user.id
          if trader.save!
            TraderMailer.with(trader: trader).send_email_receipt.deliver_later
            render json:  trader , status: 200
          else
            render json: { errors: trader.errors.full_messages }, status: 422
          end
        else
            render json: { errors: user.errors.full_messages }, status: 422
        end
      end

      def update
          user = User.where(id: single_trader[:user_id])
          if single_trader.update(trader_params)
            user.update(name: single_trader.name, email: single_trader.email)
            render json: { message: 'Trader updated successfully' }, status: 200
          else
            render json: { error: 'Trader update failed' }, status: 422
          end
      end

      def update_trader_status
        if authenticate_if_admin!
          if single_trader.update(status: 'approved')
            TraderMailer.with(trader: single_trader).approved_account_receipt.deliver_later
            render json: { status: 'approved', message: 'Trader status changed to approved' }, status: 200
          else
            render json: { error: 'Trader status change failed' }, status: 422
          end
        else
          render json: { error: 'You are not authorized to view this page.' }, status: 401
        end
      end

      def show 
        if single_trader
          render json: single_trader, status: 200
        else
          render json: { error: 'You are not authorized to view this page.' }, status: 401 
        end
      end

      def destroy
        if authenticate_if_admin!
          if single_trader.destroy
            render json: { message: 'Trader deleted successfully' }, status: 200
          else
            render json: { error: 'Trader deletion failed' }, status: 422
          end
        end
      end

      def top_up
        cash = 5000
        trader = current_api_v1_user.trader
        new_wallet = trader.update(wallet: trader.wallet + cash)
        new_wallet.save

        if new_wallet.save
          render json: { message: 'Top up is successful' }, status: 200
        else
          render json: { error: 'top up failed' }, status: 422
        end
      end

      private

      def all_trader
        Trader.all
      end

      def single_trader
        Trader.find(params[:id])
      end
    end
  end
end
