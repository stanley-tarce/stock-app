class Trader < ApplicationRecord
  belongs_to :user
  before_create :set_trader_status!
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 50 }, :uniqueness => true
  validates :user_id, presence: true
  private
  def set_trader_status!
    self.status = "pending"
  end  
end
