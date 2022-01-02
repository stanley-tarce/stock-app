class AddLogoToStocks < ActiveRecord::Migration[6.1]
  def change
    add_column :stocks, :logo, :string
  end
end
