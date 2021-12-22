class Market < ApplicationRecord
  has_many :stocks
  has_many :traders, through: :stocks 

  validates :stock_name, presence: :true
  validates :price_per_unit, presence: :true
#   Trader.first.stocks.create(market: market, stock_name:market.stock_name, shares: 100, price_per_unit: market.price_per_unit, total_price: 10
# 0*market.price_per_unit)
end
