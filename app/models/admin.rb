# frozen_string_literal: true
class Admin < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX  }
end
