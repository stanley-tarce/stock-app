# frozen_string_literal: true


class Trader < ApplicationRecord
  after_destroy :destroy_associated_data
  has_many :transaction_histories
  belongs_to :user
  before_create :set_trader_status!
  has_many :stocks
  has_many :markets, through: :stocks
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 50 }, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :user_id, presence: true

  private
  def destroy_associated_data
    self.transaction_histories.destroy_all if self.transaction_histories.present?
    self.stocks.destroy_all if self.stocks.present?
    self.user.destroy
  end
  def set_trader_status!
    self.status = 'pending'
  end
end
