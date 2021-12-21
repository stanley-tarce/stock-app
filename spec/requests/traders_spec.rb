require 'rails_helper'

RSpec.describe "Traders", type: :request do

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
      }
    }
  }

  let(:invalid_attributes) {
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
    shared_context "when user is signed in" do
      before do
        post @sign_up_url, params: @sign_up_params 
        @headers = {
          "access-token": response.headers["access-token"],
          "uid": response.headers["uid"],
          "client": response.headers["client"],
          "expiry": response.headers["expiry"]
        }
      end
    end

    describe "POST /create" do
      context "with valid parameters" do
        it "creates a new trader" do
          post api_v1_traders_path, params: valid_attributes
          expect(response).to have_http_status(:success)

          # message_delivery = instance_double(ActionMailer::MessageDelivery)
          # expect(TraderMailer).to receive(:send_email_receipt).with(@trader).and_return(message_delivery)
          # allow(message_delivery).to receive(:deliver_later)
        end
      end
      context "with invalid parameters" do
        it "returns unproccessable entity" do
          post api_v1_traders_path, params: invalid_attributes
          expect(response).to have_http_status(422)
        end
      end
    end

    context "when user is logged in" do
      describe "PATCH /update" do
        include_context "when user is signed in"
        context "with valid parameters" do
          it "updates a trader" do
            patch api_v1_trader_path(id: @trader.id), params: valid_attributes, headers: @headers, as: :json
            expect(response).to have_http_status(:success)
          end
        end
        context "with invalid parameters" do
          it "returns unproccessable entity" do
            patch api_v1_trader_path(id: @trader.id), params: invalid_attributes, headers: @headers, as: :json
            expect(response).to have_http_status(422)
          end
        end
      end
    end

    context "when user is not logged in" do
      describe "PATCH /update" do
        it "returns unauthorized" do
          patch api_v1_trader_path(id: @trader.id), params: valid_attributes, headers: @headers, as: :json
          expect(response).to have_http_status(401)
        end
      end
    end
  end
end
