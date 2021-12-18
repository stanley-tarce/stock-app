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
        user = User.create(email: trader.email, password: params[:trader][:password],
                           password_confirmation: params[:trader] [:password_confirmation], name: params[:trader][:name], user_type: 'trader')
        trader.update(user_id: user.id)
        if trader.save!
          render json: { message: 'Trader created successfully', status: :created }
          TraderMailer.with(trader: trader).send_email_receipt.deliver_later 
        else
          render json: { error: 'Trader not created', status: :unprocessable_entity }
        end
      end

      def update
          user = User.where(id: single_trader[:user_id])
          if single_trader.update(trader_params)
            user.update(name: single_trader.name, email: single_trader.email)
            render json: { message: 'Trader updated successfully' }, status: 200
          else
            render json: { error: 'Trader update failed' }, status: :unprocessable_entity
          end
      end

      def update_trader_status
        if authenticate_if_admin!
          if single_trader.update(status: 'approved')
            render json: { status: 'approved', message: 'Trader status changed to approved' }, status: 200
          else
            render json: { error: 'Trader status change failed' }, status: :unprocessable_entity
          end
        else
          render json: { error: 'You are not authorized to view this page.' }, status: :unauthorized
        end
      end

      def show 
        if authenticate_if_admin!
          render json: single_trader
        else
          render json: { error: 'You are not authorized to view this page.' }, status: :unauthorized
        end
      end

      def delete
        if authenticate_if_admin!
          if single_trader.destroy
            render json: { message: 'Trader deleted successfully' }, status: 200
          else
            render json: { error: 'Trader deletion failed' }, status: :unprocessable_entity
          end
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
