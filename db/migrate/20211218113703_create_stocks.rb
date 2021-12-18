class CreateStocks < ActiveRecord::Migration[6.1]
  def change
    create_table :stocks do |t|
      t.string :stock_name
      t.integer :unit
      t.integer :price_per_unit
      t.timestamps
    end
  end
end

