require 'rails_helper'

RSpec.describe TransactionHistory, type: :model do
    
    it "should belong to trader" do
        t = TransactionHistory.reflect_on_association(:trader)
        expect(t.macro).to eq(:belongs_to)
    end
end
