# frozen_string_literal: true


class Trader < ApplicationRecord
  has_many :transaction_histories
  belongs_to :user, dependent: :destroy # has-one
  before_create :set_trader_status!
  has_many :stocks
  has_many :markets, through: :stocks
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 50 }, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :user_id, presence: true

  private

  def set_trader_status!
    self.status = 'pending'
  end
end
