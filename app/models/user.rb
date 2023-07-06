class User < ApplicationRecord
  validates :name, :birthday, :gender, presence: true
  validates :last_latitude, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 90.0 }, allow_nil: true
  validates :last_longitude, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 90.0 }, allow_nil: true

  enum gender: %w[male female transgender questioning not_applicable]
end
