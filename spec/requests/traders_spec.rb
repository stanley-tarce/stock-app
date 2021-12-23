require 'rails_helper'

RSpec.describe "Trader API Testing", type: :request do
    let(:valid_attributes) {
    {
      :trader => {
        :name => "Leann",
        :email => "ellerreyes82@gmail.com", 
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

  before(:each) do
    @trader = FactoryBot.build(:trader)
    @user = FactoryBot.build(:user)
    @user.name = @trader.name
    @user.email = @trader.email
    @user.password = @trader.password
    @user.password_confirmation = @trader.password_confirmation
    @user.save
    @trader.user = @user
    @trader.save
    # @admin = FactoryBot.create(:admin, :user => @user)
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
      "access-token": response.headers["access-token"],
      "uid": response.headers["uid"],
      "client": response.headers["client"],
      "expiry": response.headers["expiry"]
    }
  end
  it "1. It should login with Trader credentials" do
    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body)["data"]["email"]).to eq(@user.email)
  end
  it "2. It should create a new Trader" do 
      post '/api/v1/traders', params: valid_attributes, headers: @headers
      expect(response).to have_http_status(:success)
      expect(User.find(JSON.parse(response.body)["user_id"]).name).to eq(JSON.parse(response.body)["name"])
      expect(User.find(JSON.parse(response.body)["user_id"]).user_type).to include("trader")
  end
  it "3. It should not create a new Trader with invalid attributes" do
    post '/api/v1/traders', params: invalid_attributes, headers: @headers
    expect(response).to have_http_status(:unprocessable_entity)
  end
  it "4. It should update a Trader" do
    patch "/api/v1/traders/#{User.find(JSON.parse(response.body)['data']['id']).trader.id}", params: {trader: {name: "Leann"}}, headers: @headers
    expect(response).to have_http_status(:success)
  end
  it "5. It should show Trader Data" do 
    get "/api/v1/traders/#{User.find(JSON.parse(response.body)['data']['id']).trader.id}", headers: @headers
    expect(response).to have_http_status(:success)
  end
  it "6. It should delete a Trader (ADMIN)" do
    @admin = FactoryBot.build(:admin)
    @user2 = FactoryBot.build(:user)
    @user2.name = @admin.name
    @user2.email = @admin.email
    @user2.password = @admin.password
    @user2.password_confirmation = @admin.password_confirmation
    @user2.user_type = "admin"
    @user2.save
    @admin.user = @user2
    @admin.save
    post @sign_in_url, params: {email: @user2.email, password: @user2.password}
    @headers = {
      "access-token": response.headers["access-token"],
      "uid": response.headers["uid"],
      "client": response.headers["client"],
      "expiry": response.headers["expiry"]
    }
    post '/api/v1/traders', params: valid_attributes, headers: @headers
    id = User.find(JSON.parse(response.body)["user_id"]).trader.id
    delete "/api/v1/traders/#{id}", headers: @headers
    expect(response).to have_http_status(:success)
  end
  it "7. It should update trader status to approved" do 
    @admin = FactoryBot.build(:admin)
    @user2 = FactoryBot.build(:user)
    @user2.name = @admin.name
    @user2.email = @admin.email
    @user2.password = @admin.password
    @user2.password_confirmation = @admin.password_confirmation
    @user2.user_type = "admin"
    @user2.save
    @admin.user = @user2
    @admin.save
    post @sign_in_url, params: {email: @user2.email, password: @user2.password}
    @headers = {
      "access-token": response.headers["access-token"],
      "uid": response.headers["uid"],
      "client": response.headers["client"],
      "expiry": response.headers["expiry"]
    }
    post '/api/v1/traders', params: valid_attributes, headers: @headers
    id = User.find(JSON.parse(response.body)["user_id"]).trader.id
    get "/api/v1/traders/updatestatus/#{id}" , headers: @headers
    expect(response).to have_http_status(:success)
    expect(Trader.find(id).status).to eq("approved")
  end
end

#   describe "API Testing" do
#     shared_context "when user is signed in" do
#       before do
#         post @sign_up_url, params: @sign_up_params 
#         @headers = {
#           "access-token": response.headers["access-token"],
#           "uid": response.headers["uid"],
#           "client": response.headers["client"],
#           "expiry": response.headers["expiry"]
#         }
#       end
#     end

#     describe "POST /create" do
#       context "with valid parameters" do
#         it "creates a new trader" do
#           post api_v1_traders_path, params: valid_attributes
#           expect(response).to have_http_status(:success)

#           # message_delivery = instance_double(ActionMailer::MessageDelivery)
#           # expect(TraderMailer).to receive(:send_email_receipt).with(@trader).and_return(message_delivery)
#           # allow(message_delivery).to receive(:deliver_later)
#         end
#       end
#       context "with invalid parameters" do
#         it "returns unproccessable entity" do
#           post api_v1_traders_path, params: invalid_attributes
#           expect(response).to have_http_status(422)
#         end
#       end
#     end

#     context "when user is logged in" do
#       describe "PATCH /update" do
#         include_context "when user is signed in"
#         context "with valid parameters" do
#           it "updates a trader" do
#             patch api_v1_trader_path(@trader.id), params: valid_attributes, headers: @headers, as: :json
#             expect(response).to have_http_status(:success)
#             # expect(JSON.parse(response.body)[:status]).to eq("approved")
#           end
#         end
#         context "with invalid parameters" do
#           it "returns unproccessable entity" do
#             patch api_v1_trader_path(@trader.id), params: invalid_attributes, headers: @headers, as: :json
#             expect(response).to have_http_status(422)
#           end
#         end
#       end
#     end

#     context "when user is not logged in" do
#       describe "PATCH /update" do
#         it "returns unauthorized" do
#           patch api_v1_trader_path(@trader.id), params: valid_attributes, headers: @headers, as: :json
#           expect(response).to have_http_status(401)
#         end
#       end
#     end

#     context "when user is logged in" do
#       describe "PATCH /update trader status" do
#         include_context "when user is signed in"
#         context "with valid parameters" do
#           it "updates trader status" do 
#             patch api_v1_trader_path(@trader.id), params: valid_attributes, headers: @headers, as: :json
#             expect(response).to have_http_status(200)
#             # expect(JSON.parse(response.body)["status"]).to eq("approved")
#           end
#         end
#         context "with invalid parameters" do
#           it "updates trader status" do 
#             patch api_v1_trader_path(@trader.id), params: invalid_attributes, headers: @headers, as: :json
#             expect(response).to have_http_status(422)
#           end
#         end
#       end
#     end

#     context "when user is logged in" do
#       describe "GET /show" do
#         include_context "when user is signed in"
#         context "with valid parameters" do
#           it "shows trader" do 
#             get api_v1_traders_path(@trader.id), params: valid_attributes, headers: @headers, as: :json
#             expect(response).to have_http_status(200)
#           end
#         end
#       end
#     end
#   end
# end
