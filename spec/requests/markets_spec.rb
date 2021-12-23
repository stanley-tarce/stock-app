require 'rails_helper'

RSpec.describe "Markets", type: :request do

  before(:each) do
    @user = FactoryBot.create(:user, :user_type => "admin")
    # @admin = FactoryBot.create(:admin, :user => @user)
    @market = FactoryBot.create(:market)

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

    post @sign_up_url, params: @sign_up_params 
    @headers = {
      "access-token": response.headers["access-token"],
      "uid": response.headers["uid"],
      "client": response.headers["client"],
      "expiry": response.headers["expiry"]
    }
  end

  let(:valid_attributes) {
    {
    :stock_name => "AAPL", 
    :price_per_unit => 1.5, 
    :percentage_change => "2.7",
    }
  }

  let(:invalid_attributes) {
    {
    :stock_name => nil, 
    :price_per_unit => nil, 
    :percentage_change => nil
    }
  }

  describe "API testing" do
    context "when admin is signed in" do
      describe "GET /index" do
        it "returns the list of markets" do
          get api_v1_markets_path, headers: @headers, as: :json
          expect(response).to have_http_status(:success)
        end
      end

      describe "GET /show" do
        it "returns a single market" do
          get api_v1_market_path(@market.id), headers: @headers, as: :json
          expect(response).to have_http_status(:success)
        end
      end

      describe "POST /create" do
        context "with valid parameters" do
          it "creates a new market" do
            post api_v1_markets_path, params: valid_attributes, headers: @headers, as: :json
            expect(response).to have_http_status(:success)
          end
        end
        context "with invalid parameters" do
          it "creates a new market" do
            post api_v1_markets_path, params: invalid_attributes, headers: @headers, as: :json
            expect(response).to have_http_status(422)
          end
        end
      end
      
      describe "PATCH /update" do
        context "with valid parameters" do
          it "updates the market" do
            patch api_v1_market_path(@market.id), params: valid_attributes, headers: @headers, as: :json
            expect(response).to have_http_status(:success)
          end
        end
        context "with invalid parameters" do
          it "updates the market" do
            patch api_v1_market_path(@market.id), params: invalid_attributes, headers: @headers, as: :json
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end

      describe "DELETE /delete" do
        context "with valid parameters" do
          it "deletes the current market" do
            delete api_v1_market_path(@market.id), params: valid_attributes, headers: @headers, as: :json
            expect(response).to have_http_status(:success)
          end
        end
        context "with invalid parameters" do
          it "deletes the current market" do
            delete api_v1_market_path(@market.id), params: invalid_attributes, headers: @headers, as: :json
            expect(response).to have_http_status(:success)
          end
        end
      end
    end

    context "when user is not signed in" do
      describe "GET /index" do
        it "returns the list of markets" do
          get api_v1_markets_path
          expect(response).to have_http_status(401)
        end
      end

      describe "GET /show" do
        it "returns a single market" do
          get api_v1_market_path(@market.id)
          expect(response).to have_http_status(401)
        end
      end

      describe "POST /create" do
        it "creates a new market" do
          post api_v1_markets_path, params: valid_attributes
          expect(response).to have_http_status(401)
        end
      end

      describe "PATCH /update" do
        it "updates the market" do
          patch api_v1_market_path(@market.id), params: valid_attributes
          expect(response).to have_http_status(401)
        end
      end

      describe "DELETE /delete" do
        it "deletes the current market" do
          delete api_v1_market_path(@market.id), params: valid_attributes
          expect(response).to have_http_status(401)
        end
      end
    end
  end
end
