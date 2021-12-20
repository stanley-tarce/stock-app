class CreateMarkets < ActiveRecord::Migration[6.1]
  def change
    create_table :markets do |t|
      t.string :stock_name
      t.float :price_per_unit
      t.string :percentage_change
      t.timestamps
    end
  end
end
