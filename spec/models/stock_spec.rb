require 'rails_helper'

RSpec.describe Stock, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  context "Data Creation" do
    before(:each) do
      @stock = FactoryBot.create(:stock) 
    end
    it "1. should be able to create a new stock" do 
      expect(@stock.valid?).to eq(true)
    end

    it "2. should not be able to create a new market without a stock name" do
      @stock = FactoryBot.build(:market, stock_name: nil)
      expect(@stock).to be_invalid
      expect(@stock.errors).to be_present
    end

    it "2. should not be able to create a new market without a price per unit name" do
      @stock = FactoryBot.build(:market, price_per_unit: nil)
      expect(@stock).to be_invalid
      expect(@stock.errors).to be_present
    end
  end 
end
