module StocksModule
  def stock_params
    params.require(:stock).permit(:market_id,:shares,:price_per_unit,:total_price,:trader_id,:stock_name)
  end
end