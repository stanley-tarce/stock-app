class AddSymbolToMarkets < ActiveRecord::Migration[6.1]
  def change
    add_column :markets, :symbol, :string
  end
end
