# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Transaction History', type: :model do
  before do
    @transaction_history = FactoryBot.build(:transaction_history)
    @trader = FactoryBot.create(:trader, wallet: 1000)
    @market = FactoryBot.create(:market)
    @stock = FactoryBot.create(:stock, market: @market, trader: @trader, price_per_unit: @market.price_per_unit,
                                       stock_name: @market.stock_name)
    @transaction_history.trader = @trader
    @transaction_history.stock_name = @stock.stock_name
    @transaction_history.shares = @stock.shares
    @transaction_history.price_per_unit = @stock.price_per_unit
    @transaction_history.total_price = @stock.total_price
    @transaction_history.balance = @trader.wallet - @transaction_history.total_price
  end

  it '1. It should belong to trader' do
    t = TransactionHistory.reflect_on_association(:trader)
    expect(t.macro).to eq(:belongs_to)
  end

  it '2. It should create a History' do
    @transaction_history.save
    expect(@transaction_history.valid?).to eq(true)
  end

  it '3. It should have a stock_name and should be equal to the stock_name in Stocks' do
    @transaction_history.save
    expect(@transaction_history.stock_name).to eq(@stock.stock_name)
  end

  it '4. It should have a shares and should be equal to the shares in Stocks' do
    @transaction_history.save
    expect(@transaction_history.shares).to eq(@stock.shares)
  end

  it '6. It should not create a History if stock_name is not present' do
    @transaction_history.stock_name = nil
    @transaction_history.save
    expect(@transaction_history.valid?).to eq(false)
  end

  it '7. It should not create a History if shares is not present' do
    @transaction_history.shares = nil
    @transaction_history.save
    expect(@transaction_history.valid?).to eq(false)
  end

  it '8. It should not create a History if price_per_unit is not present' do
    @transaction_history.price_per_unit = nil
    @transaction_history.save
    expect(@transaction_history.valid?).to eq(false)
  end

  it '9. It should not create a History if total_price is not present' do
    @transaction_history.total_price = nil
    @transaction_history.save
    expect(@transaction_history.valid?).to eq(false)
  end

  it '10. It should not create a History if balance is not present' do
    @transaction_history.balance = nil
    @transaction_history.save
    expect(@transaction_history.valid?).to eq(false)
  end

  it '11. It should not create a History if trader is not present' do
    @transaction_history.trader = nil
    @transaction_history.save
    expect(@transaction_history.valid?).to eq(false)
  end
end
