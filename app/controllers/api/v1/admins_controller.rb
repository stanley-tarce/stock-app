# frozen_string_literal: true

require "#{Rails.root}/app/controllers/modules/admins_module"
require "#{Rails.root}/app/controllers/modules/traders_module"
module Api
  module V1
    class AdminsController < ApplicationController
      before_action :authenticate_api_v1_user!
      include AdminsModule
      include TradersModule
      # tested
      def create_admin
        if authenticate_if_admin!
          exceptions = %i[password password_confirmation]
          admin = Admin.new(admin_params.except(*exceptions))
          user = User.create(email: admin.email, password: params[:admin][:password], password_confirmation: params[:admin][:password_confirmation],
                             user_type: 'admin')
            admin.user_id = user.id
            if admin.save!
              render json: admin, status: 200
            else
              render json: { errors: 'Admin account creation failed' }, status: :unprocessable_entity
            end
        else
          render json: { error: 'You are not authorized to view this page.' }, status: :unauthorized
        end
      end

      def create_trader
        if authenticate_if_admin!
          exceptions = %i[password password_confirmation]
          trader = Trader.new(trader_params.except(*exceptions))
          user = User.create(email: trader.email, password: params[:trader][:password], password_confirmation: params[:trader][:password_confirmation],
                             user_type: 'trader')
            trader.user_id = user.id
            if trader.save!
              render json: { message: 'Trader account created successfully' }, status: 200
            else
              render json: { error: 'Trader account creation failed' }, status: :unprocessable_entity
            end
        else
          render json: { error: 'You are not authorized to view this page.' }, status: :unauthorized
        end
      end
    end
  end
end
