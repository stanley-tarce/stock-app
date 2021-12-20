class AddWalletToTraders < ActiveRecord::Migration[6.1]
  def change
    add_column :traders, :wallet, :float
  end
end
