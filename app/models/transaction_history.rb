class TransactionHistory < ApplicationRecord
  belongs_to :trader
  validates :stock_name, presence: true
  validates :shares, presence: true
  validates :price_per_unit, presence: true
  validates :total_price, presence: true
  validates :balance, presence: true
end
