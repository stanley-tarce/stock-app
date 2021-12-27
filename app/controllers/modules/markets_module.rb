module MarketsModule
  def market_params
    params.require(:market).permit(:percentage_change, :stock_name, :price_per_unit, :symbol)
  end
end