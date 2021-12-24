# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stock, type: :model do
  before(:each) do
    @stock = FactoryBot.create(:stock)
  end

  it '1. It should be able to create a new stock' do
    expect(@stock.valid?).to eq(true)
  end

  it '2. It should not be able to create without a stock name' do
    @stock = FactoryBot.build(:stock, stock_name: nil)
    expect(@stock).to be_invalid
    expect(@stock.errors).to be_present
  end

  it '3. It should be invalid without shares' do
    @stock = FactoryBot.build(:stock, shares: nil)
    expect(@stock).to be_invalid
    expect(@stock.errors).to be_present
  end

  it '4. It should be invalid without price per unit' do
    @stock = FactoryBot.build(:stock, price_per_unit: nil)
    expect(@stock).to be_invalid
    expect(@stock.errors).to be_present
  end

  it '5. It should belong to trader' do
    t = Stock.reflect_on_association(:trader)
    expect(t.macro).to eq(:belongs_to)
  end

  it '6. It should belong to market' do
    t = Stock.reflect_on_association(:market)
    expect(t.macro).to eq(:belongs_to)
  end

  it '7. It should create total price' do
    @stock.update(shares: 3)
    @stock.update(price_per_unit: 4)
    @stock.update(total_price: @stock.shares * @stock.price_per_unit)
    expect(@stock.total_price).to eq(12)
  end
end
