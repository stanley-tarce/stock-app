class RenameStockHistoriesToTransactionHistories < ActiveRecord::Migration[6.1]
  def change
    rename_table :stock_histories, :transaction_histories
  end
end
