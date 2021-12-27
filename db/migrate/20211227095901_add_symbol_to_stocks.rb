class AddSymbolToStocks < ActiveRecord::Migration[6.1]
  def change
    add_column :stocks, :symbol, :string
  end
end
