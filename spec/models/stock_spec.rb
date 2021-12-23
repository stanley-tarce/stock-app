require 'rails_helper'

RSpec.describe Stock, type: :model do
  context "Data Creation" do
    it "should be able to create a new stock" do 
      @stock = FactoryBot.create(:stock) 
      expect(@stock.valid?).to eq(true)
    end

    it "should not be able to create without a stock name" do
      @stock = FactoryBot.build(:stock, stock_name: nil)
      expect(@stock).to be_invalid
      expect(@stock.errors).to be_present
    end

    it "should be invalid without shares" do
      @stock = FactoryBot.build(:stock, shares: nil)
      expect(@stock).to be_invalid
      expect(@stock.errors).to be_present
    end

    it "should be invalid without price per unit" do
      @stock = FactoryBot.build(:stock, price_per_unit: nil)
      expect(@stock).to be_invalid
      expect(@stock.errors).to be_present
    end

    it "should belong to trader" do
      t = Stock.reflect_on_association(:trader)
      expect(t.macro).to eq(:belongs_to)
    end

    it "should belong to market" do
      t = Stock.reflect_on_association(:market)
      expect(t.macro).to eq(:belongs_to)
    end

    it "should create total price" do
      @stock = FactoryBot.create(:stock, shares: 3, price_per_unit: 4)
      expect(@stock.total_price).to eq(12)
    end
  end 
end
