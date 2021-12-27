class AddSymbolToTransactionHistories < ActiveRecord::Migration[6.1]
  def change
    add_column :transaction_histories, :symbol, :string
  end
end
