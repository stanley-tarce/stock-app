require 'rails_helper'

RSpec.describe Admin, type: :model do
   context "Data Creation" do
    before(:each) do
      @admin = FactoryBot.create(:admin) 
    end
    it "1. should be able to create a new trader" do 
      expect(@admin.valid?).to eq(true)
    end
    it "2. should not be able to create a new admin without an email" do
      @admin = FactoryBot.build(:admin, email: nil)
      expect(@admin).to be_invalid
    end
    it "3. should not be able to create a new admin without a name" do
      @admin = FactoryBot.build(:admin, name: nil)
      expect(@admin).to be_invalid
    end
  end 
end
