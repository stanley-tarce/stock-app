# frozen_string_literal: true
require "#{Rails.root}/app/controllers/modules/admins_module"
require "#{Rails.root}/app/controllers/modules/traders_module"
module Api
  module V1
    class AdminsController < ApplicationController
      before_action :authenticate_api_v1_user!
      include AdminsModule
      include TradersModule
      def index
        if authenticate_if_admin
          render json: all_trader
        else
          render json: { error: 'You are not authorized to view this page.' }, status: :unauthorized
      end
    end
      def show 
        if authenticate_if_admin
          render json: single_trader
        else
          render json: { error: 'You are not authorized to view this page.' }, status: :unauthorized
        end
      end
      def update
        if authenticate_if_admin
          user = User.find_by(id: single_admin[:user_id])
          if single_admin.update(admin_params)
            user.update(name: single_admin.name, email: single_admin.email)
            render json: { message: 'Trader updated successfully' }, status: 200
          else
            render json: { error: 'Trader update failed' }, status: :unprocessable_entity
          end
        else
          render json: { error: 'You are not authorized to view this page.' }, status: :unauthorized
        end
      end
      def create
        if authenticate_if_admin!
          puts request.headers['access-token']
          exceptions = %i[password password_confirmation]
          admin = Admin.new(admin_params.except(*exceptions))
          user = User.create(email: admin.email, password: params[:admin][:password], password_confirmation: params[:admin][:password_confirmation],
                             user_type: 'admin')
          if user.save
            admin.user_id = user.id
            if admin.save!
              render json: admin, status: 200
            else
              render json: { errors: 'Admin account creation failed' }, status: 422
            end
          else
            render json: { errors: 'Admin account creation failed' }, status: 422
          end
        else
          render json: { error: 'You are not authorized to view this page.' }, status: 401
        end
      end

      def create_trader
        if authenticate_if_admin!
          exceptions = %i[password password_confirmation]
          trader = Trader.new(trader_params.except(*exceptions))
          user = User.new(email: trader.email, password: params[:trader][:password], password_confirmation: params[:trader][:password_confirmation],
                             user_type: 'trader')
          if user.save
            trader.user_id = user.id
            if trader.save!
              render json: { message: 'Trader account created successfully' }, status: 200
            else
              render json: { error: 'Trader account creation failed' }, status: 422
            end
          else
            render json: { error: 'Trader account creation failed' }, status: 422
          end
        else
          render json: { error: 'You are not authorized to view this page.' }, status: 401
        end
      end
      private 
      def all_admin
        Admin.all
      end
      def single_admin
        Admin.find(params[:id])
      end
    end
  end
end
