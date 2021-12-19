class Stock < ApplicationRecord
    validates :stock_name, presence: true
    validates :price_per_unit, presence: true 
    validates :unit, presence: true 
end
