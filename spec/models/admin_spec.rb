require 'rails_helper'

RSpec.describe Admin, type: :model do
 
    before(:each) do
      @admin = FactoryBot.build(:admin)
      @user = FactoryBot.create(:user, :user_type => "admin")
      @admin.user = @user
      @admin.save
    end
    it "1. It should be able to create a new admin" do 
      expect(@admin.valid?).to eq(true)
    end
    it "2. It should not be able to create a new admin without an email" do
      @admin = FactoryBot.build(:admin, email: nil)
      @admin.save
      expect(@admin).to be_invalid
    end
    it "3. It should not be able to create a new admin without a name" do
      @admin = FactoryBot.build(:admin, name: nil)
      expect(@admin).to be_invalid
    end
    it "4. It should have a user_type of admin" do
      expect(@admin.user.user_type).to eq("admin")
    end

end
