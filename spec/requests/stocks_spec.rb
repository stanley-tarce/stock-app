# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Stocks', type: :request do
  before(:each) do
    @trader = FactoryBot.build(:trader, status: 'approved')
    @user = FactoryBot.build(:user, email: @trader.email, name: @trader.name, password: @trader.password,
                                    password_confirmation: @trader.password)
    @trader.status = 'approved'
    @trader.update(user: @user)
    @user.save
    @trader.save
    @market = FactoryBot.create(:market)

    @sign_up_url = '/api/v1/auth'
    @sign_in_url = '/api/v1/auth/sign_in'

    @sign_up_params = {
      email: @user.email,
      password: @user.password,
      password_confirmation: @user.password
    }

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
  it '1. It should buy a stock with valid attributes' do
    params = {
      stock: {
        market_id: 1,
        shares: 100
      }
    }
    User.find(JSON.parse(response.body)['data']['id']).trader.update(status: 'approved')
    post "/api/v1/traders/#{@trader.id}/stocks", params: params, headers: @headers
    puts response.body
    expect(response).to have_http_status(200)
  end
  it '2. It should find the selected stock (show)' do
    User.find(JSON.parse(response.body)['data']['id']).trader.update(status: 'approved')
    @stock = FactoryBot.build(:stock, trader: @trader, market: @market, stock_name: @market.stock_name,
                                      price_per_unit: @market.price_per_unit, symbol: @market.symbol)
    @stock.total_price = @market.price_per_unit * @stock.shares
    @stock.save
    @transaction_history = FactoryBot.create(:transaction_history, trader: @trader, stock_name: @market.stock_name,
                                                                   price_per_unit: @market.price_per_unit, total_price: @market.price_per_unit * @stock.shares, balance: @trader.wallet - @stock.total_price, shares: @stock.shares, symbol: @market.symbol)
    get "/api/v1/traders/#{@trader.id}/stocks/#{Trader.find(@trader.id).stocks.first.id}", headers: @headers
    expect(response).to have_http_status(200)
  end
  it '3. It should update the stock via buy method' do
    User.find(JSON.parse(response.body)['data']['id']).trader.update(status: 'approved')
    @stock = FactoryBot.build(:stock, trader: @trader, market: @market, stock_name: @market.stock_name,
                                      price_per_unit: @market.price_per_unit, symbol: @market.symbol)
    @stock.total_price = @market.price_per_unit * @stock.shares
    @stock.save
    @transaction_history = FactoryBot.create(:transaction_history, trader: @trader, stock_name: @market.stock_name,
                                                                   price_per_unit: @market.price_per_unit, total_price: @market.price_per_unit * @stock.shares, balance: @trader.wallet - @stock.total_price, shares: @stock.shares, symbol: @market.symbol, transaction_type: 'buy')

    patch "/api/v1/traders/#{@trader.id}/buy/stocks/#{Trader.find(@trader.id).stocks.first.id}", params: { shares: 200 },
                                                                                                 headers: @headers
    expect(response).to have_http_status(200)
  end
  it '4. It should update the stock via sell method' do
    User.find(JSON.parse(response.body)['data']['id']).trader.update(status: 'approved')
    @stock = FactoryBot.build(:stock, trader: @trader, market: @market, stock_name: @market.stock_name,
                                      price_per_unit: @market.price_per_unit, symbol: @market.symbol)
    @stock.total_price = @market.price_per_unit * @stock.shares
    @stock.save
    @transaction_history = FactoryBot.create(:transaction_history, trader: @trader, stock_name: @market.stock_name,
                                                                   price_per_unit: @market.price_per_unit, total_price: @market.price_per_unit * @stock.shares, balance: @trader.wallet - @stock.total_price, shares: @stock.shares, symbol: @market.symbol, transaction_type:'sell')
    patch "/api/v1/traders/#{@trader.id}/sell/stocks/#{Trader.find(@trader.id).stocks.first.id}", params: { shares: 10 },
                                                                                                  headers: @headers
    expect(response).to have_http_status(200)
  end
  it '5. It should not create a stock if funds are insuficient' do
    User.find(JSON.parse(response.body)['data']['id']).trader.update(status: 'approved')
    User.find(JSON.parse(response.body)['data']['id']).trader.update(wallet: 0)
    params = {
      stock: {
        market_id: 1,
        shares: 100
      }
    }
    post "/api/v1/traders/#{@trader.id}/stocks", params: params, headers: @headers
    expect(response).to have_http_status(422)
  end
  it '6. It should not update a stock if funds are insuficient' do
    User.find(JSON.parse(response.body)['data']['id']).trader.update(status: 'approved')
    @stock = FactoryBot.build(:stock, trader: @trader, market: @market, stock_name: @market.stock_name,
                                      price_per_unit: @market.price_per_unit)
    @stock.total_price = @market.price_per_unit * @stock.shares
    @stock.save
    @transaction_history = FactoryBot.create(:transaction_history, trader: @trader, stock_name: @market.stock_name,
                                                                   price_per_unit: @market.price_per_unit, total_price: @market.price_per_unit * @stock.shares, balance: @trader.wallet - @stock.total_price, shares: @stock.shares)
    User.find(JSON.parse(response.body)['data']['id']).trader.update(wallet: 0)
    patch "/api/v1/traders/#{@trader.id}/buy/stocks/#{Trader.find(@trader.id).stocks.first.id}", params: { shares: 200 },
                                                                                                 headers: @headers
    expect(response).to have_http_status(422)
  end
  it '7. It should not create a stock without shares' do
    User.find(JSON.parse(response.body)['data']['id']).trader.update(status: 'approved')
    params = {
      stock: {
        market_id: 1,
        shares: nil
      }
    }
    post "/api/v1/traders/#{@trader.id}/stocks", params: params, headers: @headers
    expect(response).to have_http_status(422)
  end
end
