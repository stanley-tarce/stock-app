# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
require 'csv'
require 'json'
admindetails = [
  { name: 'Stanley Tarce', email: 'stanleytarce18@gmail.com', password: '1234567',
    password_confirmation: '1234567' }, { name: 'Leandra Panopio', email: 'leandrapanopio@gmail.com', password: '7654321', password_confirmation: '7654321' }
]
admindetails.each do |detail|
  exceptions = %i[password password_confirmation]
  admin = Admin.new(detail.except(*exceptions))
  user = User.create(email: detail[:email], password: detail[:password],
                     password_confirmation: detail[:password_confirmation], user_type: 'admin', name: detail[:name])
  admin.user_id = user.id
  admin.save!
end

# traderdetail = [{:name => "Stanley Tarce Trader", :email => "stanleytarce1801@gmail.com", :password => "1234567", :password_confirmation => "1234567"}]
# traderdetail.each do |detail|
#   exceptions = [ :password, :password_confirmation]
#   trader = Trader.new(detail.except(*exceptions))
#   user = User.create(email: detail[:email], password: detail[:password], password_confirmation: detail[:password_confirmation], user_type: "trader", name: detail[:name])
#   trader.user_id = user.id
#   trader.save!
# end

client = IEX::Api::Client.new(
  publishable_token: ENV['IEX_PUBLISHABLE_TOKEN'],
  secret_token: ENV['IEX_SECRET_TOKEN'],
  endpoint: 'https://cloud.iexapis.com/v1'
)

stocks = %w[AAPL TSLA NKE ACN UL UBER AMZN AUDVF AMD MSFT PXLW ADBE VZ CAJFF
            NINOF FUJIF SONY MBFJF TOYOF PHG CSIOF YAMHF KO PEP CAT TWTR NVDA WACMF H COST DELL GDDY SEKEF STNE BA DIS HD SBUX GME ADDDF TGT UA SSNLF INTC WYNN LVS DISCA QCOM BABAF]

stocks.each do |stock|
  quote = client.quote(stock)
  logo = client.logo(stock)
  Market.create(stock_name: quote.company_name, price_per_unit: quote.latest_price,
                percentage_change: quote.change_percent_s, symbol: stock, logo: logo)
end

# data = File.open("#{Rails.root}/markets.csv").read
# csv = CSV.new(data, :headers => true, :header_converters => :symbol)
# csv.map {|row| row.to_hash}.each do |data|
#   Market.create(stock_name: data[:stock_name], price_per_unit: data[:price_per_unit], percentage_change: data[:percentage_change], symbol: data[:symbol])
# end
