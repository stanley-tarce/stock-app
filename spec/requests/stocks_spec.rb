require 'rails_helper'

RSpec.describe "Stocks", type: :request do

  before(:each) do
    @user = FactoryBot.create(:user, :user_type => "trader")
    @trader = FactoryBot.create(:trader, :user => @user)

    @sign_up_url = api_v1_user_session_path
    @sign_in_url = api_v1_user_session_path

    @sign_up_params = {
      email: @user.email,
      password: @user.password,
      password_confirmation: @user.password
    }

    @login_params = {
      email: @user.email,
      password: @user.password
    }
  end

  let(:valid_attributes) {
    {
      :trader => {
        :name => "Leann",
        :email => "ellerreyes82@gmail.com", 
        :user_id => @user.id,
        :password => "24242424", 
        :password_confirmation => "24242424",
        :status => "approved",
      }
    }
  }

  describe "API Testing" do
    shared_context "when user is signed in" do
      before do
        post @sign_in_url, params: @login_params 
        @headers = {
          "access-token": response.headers["access-token"],
          "uid": response.headers["uid"],
          "client": response.headers["client"],
          "expiry": response.headers["expiry"]
        }
      end
    end

    # describe "GET /index" do
    #   include_context "when user is signed in"
    #   it "returns http success" do
    #     get api_v1_trader_stocks_path(@trader.id), params: valid_attributes, headers: @headers, as: :json
    #     expect(response).to have_http_status(:success)
    #   end
    # end
  
    describe "POST /create" do
      include_context "when user is signed in"
      it "returns http success" do
        post "/api/v1/traders/#{@trader.id}/stocks", params: valid_attributes, headers: @headers, as: :json
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
