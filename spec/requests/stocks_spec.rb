require 'rails_helper'

RSpec.describe "Stocks", type: :request do
  before(:each) do
    @user = FactoryBot.create(:user)
    @trader = FactoryBot.create(:trader, user: @user)
    @trader.status = "approved"
    @trader.save
    @market =FactoryBot.create(:market)
  
    @sign_up_url = api_v1_user_session_path
    @sign_in_url = api_v1_user_session_path

    @sign_up_params = {
      email: @user.email,
      password: @user.password,
      password_confirmation: @user.password,
    }

    @login_params = {
      email: @user.email,
      password: @user.password,
    }

    post @sign_up_url, params: @sign_up_params 
    @headers = {
      "access-token": response.headers["access-token"],
      "uid": response.headers["uid"],
      "client": response.headers["client"],
      "expiry": response.headers["expiry"]
    }
  end

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

      describe "GET /buy" do
        context "with valid parameters" do
          it "buys more shares of existing stock" do
            # stock = Stock.create(valid_stock_attributes)
            s = @trader.stocks.create(valid_stock_attributes)
            # patch api_v1_trader_stocks_path(@trader_id, s), headers: @headers, as: :json
            get "/api/v1/traders/#{@trader.id}/buy/stocks/#{s.id}", headers: @headers, as: :json
            expect(response).to have_http_status(:success)
          end
        end
       
      end
    end
  end
end
