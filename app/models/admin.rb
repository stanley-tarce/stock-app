class Admin < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :email , presence: true
end
