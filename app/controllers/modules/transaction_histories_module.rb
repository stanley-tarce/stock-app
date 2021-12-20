module TransactionHistoriesModule
  def transaction_history_params
    params.require(:transaction_history).permit(:shares,:price_per_unit,:total_price,:trader_id,:stock_name)
  end
end
