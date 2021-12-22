class AddTotalPrice < ActiveRecord::Migration[6.1]
  def change
    add_column :stocks, :total_price, :decimal
  end
end
