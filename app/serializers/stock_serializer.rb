class StockSerializer < ActiveModel::Serializer
  attributes :id, :stock_name, :shares, :price_per_unit, :total_price, :market_id, :trader_id, :symbol
end
