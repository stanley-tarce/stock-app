# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Market, type: :model do
  it '1. It should be able to create a new market with valid attributes' do
    @market = FactoryBot.create(:market)
    expect(@market.valid?).to eq(true)
  end

  it '2. It should not be able to create a new market without a stock_name' do
    @market = FactoryBot.build(:market, stock_name: nil)
    expect(@market).to be_invalid
    expect(@market.errors).to be_present
  end

  it '3. It should have many stocks' do
    t = described_class.reflect_on_association(:stocks)
    expect(t.macro).to eq(:has_many)
  end

  it '4. It should have many traders' do
    t = described_class.reflect_on_association(:traders)
    expect(t.macro).to eq(:has_many)
  end
end
