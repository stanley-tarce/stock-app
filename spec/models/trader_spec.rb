require 'rails_helper'

RSpec.describe Trader, type: :model do
  context "Data Creation" do
    before(:each) do
      @trader = FactoryBot.create(:trader) 
    end
    it "1. should be able to create a new trader" do 
      expect(@trader.valid?).to eq(true)
    end
    it "2. should not be able to create a new trader without an email" do
      @trader = FactoryBot.build(:trader, email: nil)
      expect(@trader).to be_invalid
    end
    it "3. should not be able to create a new trader without a name" do
      @trader = FactoryBot.build(:trader, name: nil)
      expect(@trader).to be_invalid
    end
  end 
end
