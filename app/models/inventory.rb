class Inventory < ApplicationRecord
  validates :item, :quantity, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :user

  enum item: %w[water food medicine ammo]
end
