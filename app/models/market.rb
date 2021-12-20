class Market < ApplicationRecord
  has_many :stocks
  has_many :traders, through: :stocks 
#   Trader.first.stocks.create(market: market, stock_name:market.stock_name, shares: 100, price_per_unit: market.price_per_unit, total_price: 10
# 0*market.price_per_unit)
end
