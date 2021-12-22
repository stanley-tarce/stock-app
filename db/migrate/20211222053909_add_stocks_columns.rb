class Addstockcolumns < ActiveRecord::Migration[6.1]
  def change
    add_column :stocks, :shares, :integer
    add_belongs_to :stocks, :trader
    add_belongs_to :stocks, :market
  end
end
