require 'rails_helper'

RSpec.describe "Stocks", type: :request do
  let(:valid_stocks_attributes) {
    {
      :stock => {
        :shares => "3", 
        :price_per_unit => "4",
        :total_price => "12", 
        :trader_id => @trader.id,
        :stock_name => "AAPL",
        :market_id => @market.id,
      }

    }
  }

  let(:valid_stock_attributes) {
    {  
      :shares => "3", 
      :price_per_unit => "4",
      :total_price => "12", 
      :trader_id => @trader.id,
      :stock_name => "AAPL",
      :market_id => @market.id,
    }
  }

  let(:invalid_stocks_attributes) {
    {
      :stock => {
        :shares => nil, 
        :price_per_unit => nil,
        :total_price => nil, 
        :stock_name => nil,
        :trader_id => nil,
        :market_id => @market.id,
      }
    }
  }

  before(:each) do
    @user = FactoryBot.create(:user)
    @trader = FactoryBot.create(:trader, user: @user)
    @trader.status = "approved"
    @trader.save
    @market =FactoryBot.create(:market)
  
    @sign_up_url = '/api/v1/auth'
    @sign_in_url = '/api/v1/auth/sign_in'

    @sign_up_params = {
      email: @user.email,
      password: @user.password,
      password_confirmation: @user.password,
    }

    @login_params = {
      email: @user.email,
      password: @user.password,
    }

    post @sign_in_url, params: @login_params 
    @headers = {
      "access-token": response.headers["access-token"],
      "uid": response.headers["uid"],
      "client": response.headers["client"],
      "expiry": response.headers["expiry"]
    }
  end

  describe "API Testing" do
    context "when admin is signed in" do
      describe "GET /index" do
        it "returns the list of stocks a trader owns" do
          get api_v1_trader_stocks_path(@trader.id), headers: @headers, as: :json
          expect(response).to have_http_status(:success)
        end
      end
    
      describe "POST /create" do
        context "with valid parameters" do
          it "creates or buys a new stock" do
            post api_v1_trader_stocks_path(@trader.id), params: valid_stocks_attributes, headers: @headers, as: :json
            expect(response).to have_http_status(:success)
          end
        end
        context "with invalid parameters" do
          it "creates or buys a new stock" do
            post api_v1_trader_stocks_path(@trader.id), params: invalid_stocks_attributes, headers: @headers, as: :json
            expect(response).to have_http_status(422)
          end
        end
      end

      describe "POST /buy" do
        context "with valid parameters" do
          it "buys more shares of existing stock" do
            s = @trader.stocks.create(valid_stock_attributes)
            post "/api/v1/traders/#{@trader.id}/buy/stocks/#{s.id}", params: valid_stocks_attributes, headers: @headers, as: :json
            expect(response).to have_http_status(:success)
          end
        end
      end

      describe "POST /sell" do
        context "with valid parameters" do
          it "sells shares" do
            s = @trader.stocks.create(valid_stock_attributes)
            post "/api/v1/traders/#{@trader.id}/sell/stocks/#{s.id}", params: valid_stocks_attributes, headers: @headers, as: :json
            expect(response).to have_http_status(:success)
          end
        end
      end
    end
  end
end
