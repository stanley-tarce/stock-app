require 'rails_helper'

RSpec.describe Market, type: :model do

  context "Data Creation" do
    before(:each) do
      @market = FactoryBot.create(:market) 
    end
    it "1. should be able to create a new market" do 
      expect(@market.valid?).to eq(true)
    end

    it "2. should not be able to create a new market without a stock name" do
      @market = FactoryBot.build(:market, stock_name: nil)
      expect(@market).to be_invalid
      expect(@market.errors).to be_present
    end

    it "2. should not be able to create a new market without a price per unit name" do
      @market = FactoryBot.build(:market, price_per_unit: nil)
      expect(@market).to be_invalid
      expect(@market.errors).to be_present
    end
  end 
end
