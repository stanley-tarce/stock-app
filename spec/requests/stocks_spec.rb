require 'rails_helper'

RSpec.describe "Stocks", type: :request do

  before(:each) do
    @user = FactoryBot.create(:user)
    @trader = FactoryBot.create(:trader, :status => "approved")
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
  end

  let(:valid_stocks_attributes) {
    {
      :stock => {
        :shares => "25", 
        :price_per_unit => "250",
        :total_price => "6250", 
        :trader_id => @trader.id,
        :stock_name => "AAPL",
        :market_id => @market.id,
      }
    }
  }

  describe "API Testing" do
    before(:each) do
      post @sign_up_url, params: @sign_up_params 
      @headers = {
        "access-token": response.headers["access-token"],
        "uid": response.headers["uid"],
        "client": response.headers["client"],
        "expiry": response.headers["expiry"]
      }
    end

    # describe "GET /index" do
    #   include_context "when user is signed in"
    #   it "returns http success" do
    #     get api_v1_trader_stocks_path(@trader.id), params: valid_attributes, headers: @headers, as: :json
    #     expect(response).to have_http_status(:success)
    #   end
    # end
  
    describe "POST /create" do
      it "returns http success" do
        post "/api/v1/traders/#{@trader.id}/stocks", params: valid_stocks_attributes, headers: @headers, as: :json
        expect(response).to have_http_status(:success)
      end
    end
  
    describe "GET /update" do
      it "returns http success" do
        get "/stocks/update"
        expect(response).to have_http_status(:success)
      end
    end
  
    describe "GET /destroy" do
      it "returns http success" do
        get "/stocks/destroy"
        expect(response).to have_http_status(:success)
      end
    end
  
    describe "GET /show" do
      it "returns http success" do
        get "/stocks/show"
        expect(response).to have_http_status(:success)
      end
    end
  
  end
  
end
