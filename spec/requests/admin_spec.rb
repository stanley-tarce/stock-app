require 'rails_helper'

RSpec.describe "Admins", type: :request do

  
  before(:each) do
    @user = FactoryBot.create(:user, :user_type => "admin")
    @admin = FactoryBot.create(:admin, :user => @user)

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
    :email => "ellerreyes82@gmail.com", 
    :password => "24242424", 
    :password_confirmation => "24242424"
    }
  }

  let(:invalid_attributes) {
    {
    :email => nil, 
    :password => nil, 
    :password_confirmation => nil
    }
  }

  let(:valid_trader_attributes) {
    {
      :trader => {
        :name => "Leann",
        :email => "ellerreyes82@gmail.com", 
        :user_id => @user.id,
        :password => "24242424", 
        :password_confirmation => "24242424",
      }
    }
  }
  let(:invalid_trader_attributes) {
    {
      :trader => {
        :name => nil,
        :email => nil,
        :user_id => nil,
        :password => nil,
        :password_confirmation => nil,
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

    context "when admin is signed in" do
      describe "GET /index" do
        it "returns the list of admins" do
          get api_v1_admins_path, headers: @headers, as: :json
          expect(response).to have_http_status(:success)
        end
      end

      describe "POST /create" do
        context "with valid parameters" do
          it "creates a new admin" do
            post api_v1_admins_path, params: valid_attributes, headers: @headers, as: :json
            expect(response).to have_http_status(:success)
          end
        end
        context "with invalid parameters" do
          it "creates a new admin" do
            post api_v1_admins_path, params: invalid_attributes, headers: @headers, as: :json
            expect(response).to have_http_status(422)
          end
        end
      end

      describe "PATCH /update" do
        context "with valid parameters" do
          it "updates an admin" do
            patch api_v1_admin_path(id: @admin.id), params: valid_attributes, headers: @headers, as: :json
            expect(response).to have_http_status(:success)
          end
        end
        context  "with invalid parameters" do
          it "updates an admin" do
            patch api_v1_admin_path(id: @admin.id), params: invalid_attributes, headers: @headers, as: :json
            expect(response).to have_http_status(422)
          end
        end
      end

      describe "GET /show" do
        it "returns one specific admin" do
          get api_v1_admin_path(id: @admin.id), headers: @headers, as: :json
          expect(response).to have_http_status(:success)
        end
      end

      describe "POST /create_trader" do
        context "with valid parameters" do
          it "creates a trader account" do
            post api_v1_admins_create_trader_path, params: valid_trader_attributes, headers: @headers, as: :json
            expect(response).to have_http_status(:success)
          end
        end

        context "with invalid parameters" do
          it "creates a trader account" do
            post api_v1_admins_create_trader_path, params: invalid_trader_attributes, headers: @headers, as: :json
            expect(response).to have_http_status(422)
          end
        end
      end
    end

    context "when admin is not signed in" do
      describe "GET /index" do
        it "returns unauthorized" do
          get api_v1_admins_path
          expect(response).to have_http_status(401)
        end
      end

      describe "POST /create" do
        it "POST /create returns unauthorized" do
          post api_v1_admins_path, params: valid_attributes
          expect(response).to have_http_status(401)
        end
      end

      describe "PATCH /update" do
        it "returns unauthorized" do
          patch api_v1_admin_path(id: @admin.id), params: valid_attributes
          expect(response).to have_http_status(401)
        end
      end

      describe "GET /show" do
        it "returns unauthorized" do
          get api_v1_admin_path(id: @admin.id)
          expect(response).to have_http_status(401)
        end
      end

      describe "POST /create_trader" do
        it "returns unauthorized" do
          post api_v1_admins_create_trader_path, params: valid_trader_attributes
          expect(response).to have_http_status(401)
        end
      end
    end
  end
end
