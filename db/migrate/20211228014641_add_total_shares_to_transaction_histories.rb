class AddTotalSharesToTransactionHistories < ActiveRecord::Migration[6.1]
  def change
    add_column :transaction_histories, :total_shares, :float
  end
end
