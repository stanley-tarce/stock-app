require 'rails_helper'

RSpec.describe "Admin API Testing", type: :request do
  let(:admin_attributes) {
   { :admin => {
      :name => "Leandra",
      :email => "ellerreyes82@gmail.com", 
      :password => "24242424", 
      :password_confirmation => "24242424"
    }}
  }
    let(:invalid_admin_attributes) {
   { :admin => {
      :name => nil,
      :email => nil, 
      :password => "24242424", 
      :password_confirmation => "24242424"
    }}
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
  before(:each) do
    @user = FactoryBot.create(:user, :user_type => "admin")
    @admin = FactoryBot.create(:admin, :user => @user, :name => @user.name, :email => @user.email)
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
  it "1. It should be able to create an admin account using the API (admins#create)" do
    post '/api/v1/admins', params: admin_attributes, headers: @headers
    expect(response).to have_http_status(:success)
    expect(response.body).to include(admin_attributes[:admin][:name])
    expect(response.body).to include(admin_attributes[:admin][:email])
    expect(Admin.find(JSON.parse(response.body)["id"]).user.user_type).to eq("admin")
  end
  it "2. It should not be able to create an admin with invalid attributes ERROR (admins#create)" do
    post '/api/v1/admins', params: invalid_admin_attributes, headers: @headers
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to include("Admin account creation failed")
  end
  it  "3. It should be able to view all admins (admins#index)" do
    get '/api/v1/admins', headers: @headers
    expect(response).to have_http_status(:success)
    expect(response.body).to include(@admin.name)
    expect(response.body).to include(@admin.email)
  end
  it "4. It should be able to view a single admin (admins#show)" do
    get "/api/v1/admins/#{@admin.id}", headers: @headers
    expect(response).to have_http_status(:success)
    expect(response.body).to include(@admin.name)
    expect(response.body).to include(@admin.email)
  end
  it "5. It should be able to update an admin (admins#update)" do
    patch "/api/v1/admins/#{@admin.id}" , params: {admin: {name: "Stanley", email: "stanleytarce18@gmail.com"}}, headers: @headers
    expect(response).to have_http_status(:success)
    expect(Admin.first.name).to eq("Stanley")
    expect(Admin.first.user.name).to eq("Stanley")
  end
  it "6. It should create a trader account (admins#create_trader)" do
    post "/api/v1/admins/create_trader", params: valid_trader_attributes, headers: @headers
    expect(response).to have_http_status(:success)
    expect(response.body).to include(valid_trader_attributes[:trader][:name])
    expect(Trader.find(JSON.parse(response.body)["id"]).user.user_type).to eq("trader")
    expect(Trader.find(JSON.parse(response.body)["id"]).user.email).to eq("ellerreyes82@gmail.com")
  end
  it "7. It should not create a trader account without headers (admins#create_trader)" do
    post "/api/v1/admins/create_trader", params: valid_trader_attributes
    expect(response).to have_http_status(:unauthorized)
  end
  it "8. It should update an admin with one attribute (admins#update_admin)" do
    patch "/api/v1/admins/#{@admin.id}" , params: {admin: {name: "Stanley"}}, headers: @headers
    expect(response).to have_http_status(:success)
    expect(Admin.first.name).to eq("Stanley")
    expect(Admin.first.user.name).to eq("Stanley")
    expect(Admin.first.email).to eq(@admin.email)
  end
  it "9. It should not create a trader with invalid attributes (admins#create_trader)" do
    post "/api/v1/admins/create_trader", params: invalid_trader_attributes, headers: @headers
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.body).to include("Trader account creation failed")
  end
 end

