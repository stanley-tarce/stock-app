# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

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
 

#   client = IEX::Api::Client.new(
#   publishable_token: ENV['iex_publishable_token'],
#   secret_token: Figaro.env.iex_secret_token,
#   endpoint: 'https://cloud.iexapis.com/v1'
# )
  
