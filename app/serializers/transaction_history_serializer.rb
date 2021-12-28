class TransactionHistorySerializer < ActiveModel::Serializer
  attributes :id, :stock_name, :shares,  :price_per_unit, :total_price, :balance, :trader_id, :transaction_type, :symbol, :total_shares
end
