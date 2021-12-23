# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:

  admindetails = [{:name => "Stanley Tarce", :email => "stanleytarce18@gmail.com", :password => "1234567", :password_confirmation => "1234567"} ]
  admindetails.each do |detail|
    exceptions = [ :password, :password_confirmation]
    admin = Admin.new(detail.except(*exceptions))
    user = User.create(email: detail[:email], password: detail[:password], password_confirmation: detail[:password_confirmation], user_type: "admin", name: detail[:name])
    admin.user_id = user.id
    admin.save!
  end

  traderdetail = [{:name => "Stanley Tarce", :email => "stanleytarce181@gmail.com", :password => "1234567", :password_confirmation => "1234567"}]
  traderdetail.each do |detail|
    exceptions = [ :password, :password_confirmation]
    trader = Trader.new(detail.except(*exceptions))
    user = User.create(email: detail[:email], password: detail[:password], password_confirmation: detail[:password_confirmation], user_type: "trader", name: detail[:name])
    trader.user_id = user.id
    trader.save!
  end
 

  client = IEX::Api::Client.new(
    publishable_token: 'pk_9a4005e57b274b3d9e2bd747f1b34bb5',
    secret_token: 'sk_c0449ed5b4dc4051b2793339526c980c',
    endpoint: 'https://cloud.iexapis.com/v1'
  )

  stocks = [ 'AAPL', 'TSLA', 'NKE' ]
  stocks.each do |stock|
    quote = client.quote(stock)
    Market.create(stock_name: stock, price_per_unit: quote.latest_price, percentage_change: quote.change_percent_s)
  end
  
