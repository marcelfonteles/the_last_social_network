class User < ApplicationRecord
  include DatabaseOperations

  validates :name, :birthday, :gender, presence: true
  validates :last_latitude, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 90.0 }, allow_nil: true
  validates :last_longitude, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 180.0 }, allow_nil: true
  validates :warning_count, numericality: { greater_than_or_equal_to: 0 }, allow_nil: false

  has_many :inventories

  accepts_nested_attributes_for :inventories

  enum gender: %w[male female transgender questioning not_applicable]

  def amount_of(item)
    raise ActiveRecord::RecordNotFound unless Inventory.items.keys.include? item.to_s

    inventories.find_by(item:)
  end

  def amount_of_water
    amount_of('water')
  end

  def amount_of_food
    amount_of('food')
  end

  def amount_of_medicine
    amount_of('medicine')
  end

  def amount_of_ammo
    amount_of('ammo')
  end
end
