class CreateStockHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :stock_histories do |t|
      t.string :stock_name
      t.integer :shares
      t.float :price_per_unit
      t.float :total_price
      t.float :balance
      t.belongs_to :trader
      t.timestamps
    end
  end
end
