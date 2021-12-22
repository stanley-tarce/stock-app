require 'rails_helper'

RSpec.describe Market, type: :model do

  context "Data Creation" do
   
    it "should be able to create a new market with valid attributes" do 
      @market = FactoryBot.create(:market) 
      expect(@market.valid?).to eq(true)
    end

    it "should not be able to create a new market without a stock_name" do
      @market = FactoryBot.build(:market, stock_name: nil)
      expect(@market).to be_invalid
      expect(@market.errors).to be_present
    end

    it "should have many stocks" do

      t = Market.reflect_on_association(:stocks)
      expect(t.macro).to eq(:has_many)
    end

    it "should have many traders" do
      t = Market.reflect_on_association(:traders)
      expect(t.macro).to eq(:has_many)
    end
  end 
end
