# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Trader API Testing', type: :request do
  let(:valid_attributes) do
    {
      trader: {
        name: 'Leann',
        email: 'ellerreyes82@gmail.com',
        password: '24242424',
        password_confirmation: '24242424'
      }
    }
  end

  let(:invalid_attributes) do
    {
      trader: {
        name: nil,
        email: nil,
        user_id: nil,
        password: nil,
        password_confirmation: nil
      }
    }
  end

  let(:mail) { TraderMailer.send_email_receipt }

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
  it '1. It should login with Trader credentials' do
    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body)['data']['email']).to eq(@user.email)
  end
  it '2. It should create a new Trader' do
    post '/api/v1/traders', params: valid_attributes, headers: @headers
    expect(response).to have_http_status(:success)
    expect(User.find(JSON.parse(response.body)['user_id']).name).to eq(JSON.parse(response.body)['name'])
    expect(User.find(JSON.parse(response.body)['user_id']).user_type).to include('trader')
  end

  it '3. It should not create a new Trader with invalid attributes' do
    post '/api/v1/traders', params: invalid_attributes, headers: @headers
    expect(response).to have_http_status(:unprocessable_entity)
  end
  it '4. It should update a Trader' do
    patch "/api/v1/traders/#{User.find(JSON.parse(response.body)['data']['id']).trader.id}",
          params: { trader: { name: 'Leann' } }, headers: @headers
    expect(response).to have_http_status(:success)
  end
  it '5. It should show Trader Data' do
    get "/api/v1/traders/#{User.find(JSON.parse(response.body)['data']['id']).trader.id}", headers: @headers
    expect(response).to have_http_status(:success)
  end
  it '6. It should delete a Trader (ADMIN)' do
    @admin = FactoryBot.build(:admin)
    @user2 = FactoryBot.build(:user)
    @user2.name = @admin.name
    @user2.email = @admin.email
    @user2.password = @admin.password
    @user2.password_confirmation = @admin.password_confirmation
    @user2.user_type = 'admin'
    @user2.save
    @admin.user = @user2
    @admin.save
    post @sign_in_url, params: { email: @user2.email, password: @user2.password }
    @headers = {
      "access-token": response.headers['access-token'],
      "uid": response.headers['uid'],
      "client": response.headers['client'],
      "expiry": response.headers['expiry']
    }
    post '/api/v1/traders', params: valid_attributes, headers: @headers
    id = User.find(JSON.parse(response.body)['user_id']).trader.id
    delete "/api/v1/traders/#{id}", headers: @headers
    expect(response).to have_http_status(:success)
  end
  it '7. It should update trader status to approved' do
    @admin = FactoryBot.build(:admin)
    @user2 = FactoryBot.build(:user)
    @user2.name = @admin.name
    @user2.email = @admin.email
    @user2.password = @admin.password
    @user2.password_confirmation = @admin.password_confirmation
    @user2.user_type = 'admin'
    @user2.save
    @admin.user = @user2
    @admin.save
    post @sign_in_url, params: { email: @user2.email, password: @user2.password }
    @headers = {
      "access-token": response.headers['access-token'],
      "uid": response.headers['uid'],
      "client": response.headers['client'],
      "expiry": response.headers['expiry']
    }
    post '/api/v1/traders', params: valid_attributes, headers: @headers
    id = User.find(JSON.parse(response.body)['user_id']).trader.id
    get "/api/v1/traders/updatestatus/#{id}", headers: @headers
    expect(response).to have_http_status(:success)
    expect(Trader.find(id).status).to eq('approved')
  end
  it '8. It should let the trader cash in ' do
    cash_in = "/api/v1/traders/#{User.find(JSON.parse(response.body)['data']['id']).trader.id}/cash_in"
    patch cash_in, params: { trader: { wallet: '1000' } }, headers: @headers

    expect(response).to have_http_status(:success)
  end
  it '9. It should let the trader cash out' do
    cash_out = "/api/v1/traders/#{User.find(JSON.parse(response.body)['data']['id']).trader.id}/cash_out"
    patch cash_out, params: { trader: { wallet: '1000' } }, headers: @headers

    expect(response).to have_http_status(:success)
  end
  it '10. It should render an error if wallet is nil for cash in' do
    cash_in = "/api/v1/traders/#{User.find(JSON.parse(response.body)['data']['id']).trader.id}/cash_in"
    patch cash_in, params: { trader: { wallet: nil } }, headers: @headers

    expect(response).to have_http_status(:unprocessable_entity)
  end
  it '11. It should render an error if wallet is nil for cash out' do
    cash_out = "/api/v1/traders/#{User.find(JSON.parse(response.body)['data']['id']).trader.id}/cash_out"
    patch cash_out, params: { trader: { wallet: 'asd' } }, headers: @headers

    expect(response).to have_http_status(:unprocessable_entity)
  end
end
