# frozen_string_literal: true
VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
class Admin < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX  }
end
