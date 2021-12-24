# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Markets', type: :request do
  let(:market_attributes) do
    {
      stock_name: 'AAPL',
      price_per_unit: 1.5,
      percentage_change: '2.7'
    }
  end

  let(:invalid_market_attributes) do
    {
      stock_name: nil,
      price_per_unit: nil,
      percentage_change: nil
    }
  end

  before(:each) do
    @user = FactoryBot.create(:user, user_type: 'admin')
    @market = FactoryBot.create(:market)

    @sign_up_url = '/api/v1/auth'
    @sign_in_url = '/api/v1/auth/sign_in'

    @login_params = {
      email: @user.email,
      password: @user.password
    }

    post @sign_in_url, params: @login_params
    @headers = {
      "access-token": response.headers['access-token'],
      "uid": response.headers['uid'],
      "client": response.headers['client'],
      "expiry": response.headers['expiry']
    }
  end

  context 'When user is signed in' do
    it '1. It should return the list of markets (markets#index)' do
      get '/api/v1/markets', headers: @headers, as: :json
      expect(response).to have_http_status(:success)
      expect(response.body).to include(@market.stock_name)
    end

    it '2. It should return a single market (markets#show)' do
      get "/api/v1/markets/#{@market.id}", headers: @headers, as: :json
      expect(response).to have_http_status(:success)
      expect(response.body).to include(@market.stock_name)
    end

    it '3. It should create a new market (markets#create)' do
      post '/api/v1/markets', params: market_attributes, headers: @headers, as: :json
      expect(response).to have_http_status(:success)
      expect(Market.count).to eq(2)
    end

    it '4. It should not be able to create a new market' do
      post '/api/v1/markets', params: invalid_market_attributes, headers: @headers, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it '5. It should update the market (markets#update)' do
      patch "/api/v1/markets/#{@market.id}", params: { stock_name: 'NKE', price_per_unit: 2, percentage_change: '3.0' },
                                             headers: @headers, as: :json
      expect(response).to have_http_status(:success)
      expect(Market.last.stock_name).to eq('NKE')
      expect(Market.last.price_per_unit).to eq(2)
      expect(Market.last.percentage_change).to eq('3.0')
    end

    it '6. It should not be able to update a market' do
      patch "/api/v1/markets/#{@market.id}", params: invalid_market_attributes, headers: @headers, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it '7. It should delete selected market' do
      delete "/api/v1/markets/#{@market.id}", params: market_attributes, headers: @headers, as: :json
      expect(response).to have_http_status(:success)
      expect(Market.count).to eq(0)
    end
  end

  context 'When user is not signed in' do
    it '8. It should not be able to view all markets (markets#index)' do
      get '/api/v1/markets'
      expect(response).to have_http_status(:unauthorized)
    end

    it '9. It should not be able to view a single market (markets#show)' do
      get "/api/v1/markets/#{@market.id}"
      expect(response).to have_http_status(:unauthorized)
    end

    it '10. It should not be able to create a market (markets#create)' do
      post '/api/v1/markets', params: market_attributes
      expect(response).to have_http_status(:unauthorized)
    end

    it '11. It should not be able to update a market (markets#update)' do
      patch "/api/v1/markets/#{@market.id}", params: market_attributes
      expect(response).to have_http_status(:unauthorized)
    end

    it '12. It should not be able to delete a market (markets#delete)' do
      delete "/api/v1/markets/#{@market.id}", params: market_attributes
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
