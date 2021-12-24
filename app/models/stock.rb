# frozen_string_literal: true

class Stock < ApplicationRecord
  before_create :create_total_price # This will Create total price
  validates :stock_name, presence: true
  validates :shares, presence: true
  validates :price_per_unit, presence: true
  belongs_to :trader, dependent: :destroy
  belongs_to :market

  private

  def create_total_price
    self.total_price = shares * price_per_unit
  end
end
