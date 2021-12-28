class CreateStocks < ActiveRecord::Migration[6.1]
  def change
    create_table :stocks do |t|
      t.string :stock_name
      t.integer :shares
      t.float :price_per_unit
      t.float :total_price
      t.belongs_to :trader
      t.belongs_to :market
      t.timestamps
    end
  end
end

