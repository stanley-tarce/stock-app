class AddTransactiionTypeToTransactionHistories < ActiveRecord::Migration[6.1]
  def change
    add_column :transaction_histories, :transaction_type, :string
  end
end
