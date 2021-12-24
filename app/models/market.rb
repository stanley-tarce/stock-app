# frozen_string_literal: true

class Market < ApplicationRecord
  has_many :stocks
  has_many :traders, through: :stocks
  validates :stock_name, presence: true
  validates :price_per_unit, presence: true
end
