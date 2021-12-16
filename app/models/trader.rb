class Trader < ApplicationRecord
  belongs_to :user
  before_create :set_trader_status!
  private
  def set_trader_status!
    self.status = "pending"
  end  
end
